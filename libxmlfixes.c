#define _GNU_SOURCE

#include "libxmlfixes.h"
#include <libxml/HTMLparser.h>
#include <assert.h>
#include <string.h> // strlen
#include <sys/stat.h>
#include <sys/mman.h> // mmap
#include <unistd.h> // close, read

void libxml2SUCKS(xmlNode* cur) {
    /* libxml2 is stupid about namespaces.
			 wait, but doesn't it adjust the namespaces?
     * When you copy a node from one document to another, it does not adjust the namespaces to accomodate. That results in a document along the lines of
     * <html xmlns="somecrappylongurlthatispointless">...<i xmlns="theothernamespaceintheolddocument">italic</i>...</html>
     *
     * The xmlns attribute is moronic in of itself, but it is necessary to just blindly leak any
     * namespaces in the old document (since they can't be freed without guaranteeing double frees)
     * so it doesn't pollute the new document with xmlns all over the place.
     *
     * That's not all. libxml2 is moronic about namespaces in that it does not consult a lookup table
     * to produce a namespace by URL. So despite URLs being unique identifiers for namespaces, it
     * ignores that and just creates namespaces as they're needed to be created during parsing.
     *
     * That means you end up with (and I kid you not) XML like this:
     * <html xmlns="http://www.w3.org/1999/xhtml"> ... <i xmlns="http://www.w3.org/1999/xhtml">italic</i> ...</html>
     *
     * That's right. libxml2 will set the xmlns attribute for child nodes in the SAME NAMESPACE AS
     * THE PARENT. Because libxml2 doesn't use a lookup table, and there's no way to tell the parser
     * which namespace object to use, when you parse one document in a namespace, then parse another
     * document in the exact same namespace, they will have DIFFERENT namespace objects, with the same URL.
     * So libxml2 sees a child node with a different namespace object in memory and assumes the URL
     * must be different (despite denying the capability to reuse namespace objects) and dutifully
     * sets the xmlns attribute... to the same namespace as it's already in.
     *
     * Only solutions may be #1: leak all namespace objects in the old document by setting them NULL,
     * so it doesn't ever set xmlns attributes for any child elements copied over to the new document.
     * or #2: leak all namespace objects in the old document, by setting them to the namespace of
     * the new one, but only if the old namespace has the same URL as the new one.
     *
     * In both cases libxml2 will create a hard coded namespace object for both documents setting it
     * recursively and this may not be avoided or overridden, so you just have to descend through
     * the document tree a SECOND time, setting all the namespaces for each element to NULL or whatever.
     *
     * And what the hell is nsDef? Off with its head!
     */
    if(cur==NULL) return;
    cur->ns = NULL;
    cur->nsDef = NULL;
    libxml2SUCKS(cur->children);
    libxml2SUCKS(cur->next);
}

void HTML5_plz(xmlDoc* doc) {
	// html5 please
	doc->intSubset->ExternalID = NULL;
	doc->intSubset->SystemID = NULL;
}

/* just a libxml2 fix */

#define HEADER "<!DOCTYPE html>\n"							\
    "<html><body>"

#define FOOTER "</body></html>"

#define BUFSIZE 0x1000

/* read a HTML document that isn't necessarily well formed,
	 or use content as doc */

xmlDoc* strFunky(const char* content, size_t len) {
    htmlParserCtxtPtr ctx;
    ctx = htmlCreatePushParserCtxt(NULL, NULL,
                                   "",0,"htmlish.xml",
								   XML_CHAR_ENCODING_UTF8);
    assert(ctx);
    htmlCtxtUseOptions(ctx,
											 HTML_PARSE_NONET |
											 HTML_PARSE_COMPACT |
											 HTML_PARSE_RECOVER |
											 HTML_PARSE_NOWARNING
											 /* since warnings can't be filtered, just ignore them */
					   );
    htmlParseChunk(ctx, HEADER, sizeof(HEADER)-1, 0);
		htmlParseChunk(ctx,content,len,0);
    htmlParseChunk(ctx,FOOTER,sizeof(FOOTER)-1, 1);
    xmlDoc* doc = ctx->myDoc;
		HTML5_plz(doc);
    if(!ctx->wellFormed) {
        fprintf(stderr,"Warning: not well formed.\n");
    }
    xmlFreeParserCtxt(ctx);
    libxml2SUCKS(doc->children);
    return doc;
}

xmlDoc* readFunky(int fd, const char* content, size_t clen) {
	if(fd<0) {
		return strFunky(content,clen);
	} else {
		struct stat info;
		if(0 == fstat(fd,&info) && info.st_size > BUFSIZE) {
			char* buf = mmap(NULL,info.st_size,PROT_READ,MAP_PRIVATE,fd,0);
			assert(buf != MAP_FAILED);
			xmlDoc* ret = strFunky(buf,info.st_size);
			munmap(buf,info.st_size);
			return ret;
		} else {
			char buf[0x10000];
			ssize_t amt = read(fd,buf,0x10000);
			assert(amt < 0x10000);
			return strFunky(buf,amt);
		}
	}
}

xmlNode* fuckXPath(xmlNode* parent, const char* name) {
    if(strcmp(parent->name,name)==0)
        return parent;
    xmlNode* cur = parent->children;
    for(;cur;cur=cur->next) {
        xmlNode* ret = fuckXPath(cur,name);
        if(ret)
            return ret;
    }
    return NULL;
}

xmlNode* fuckXPathDivId(xmlNode* parent, const char* id) {
    if(strcmp(parent->name,"div")==0) {
        const char* test = xmlGetProp(parent,"id");
        if(test && strcmp(test,id) == 0)
            return parent;
    }
    xmlNode* cur = parent->children;
    for(;cur;cur=cur->next) {
        xmlNode* ret = fuckXPathDivId(cur,id);
        if(ret)
            return ret;
    }
    return NULL;
}

xmlNode* findOrCreate(xmlNode* parent, const char* path) {
    if(*path == 0)
        return parent;

    const char* next = strchrnul(path,'/');
    xmlNode* cur = parent->children;
    for(;cur;cur = cur->next) {
        if(0==memcmp(cur->name,path,next-path)) {
            return findOrCreate(cur,next);
        }
    }

    static char name[0x100];
    memcpy(name,path,next-path);
    name[next-path] = 0;
    xmlNode* new = xmlNewNode(parent->ns,name);
    xmlAddChild(parent,new);
    return findOrCreate(new,next);
}

void foreachNode(xmlNode* parent, const char* name, void (*handle)(xmlNode*,void*), void* ctx) {
    if(!parent->name) {
        assert(!parent->children);
        // we don't process text
        return;
    }
    if(strcmp(parent->name,name)==0)
        handle(parent,ctx);
    xmlNode* cur = parent->children;
    while(cur) {
        xmlNode* next = cur->next;
        foreachNode(cur,name,handle,ctx);
        cur = next;
    }
}
