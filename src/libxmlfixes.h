#include <libxml/tree.h> // xmlNode

xmlNode* fuckXPath(xmlNode* parent, const char* name);
xmlNode* fuckXPathDivId(xmlNode* parent, const char* id);
xmlNode* findOrCreate(xmlNode* parent, const char* path);
void foreachNode(xmlNode* parent, const char* name, void (*handle)(xmlNode*,void*), void* ctx);
xmlDoc* readFunky(int fd, const char* content, size_t len);
xmlDoc* strFunky(const char* content, size_t len);
void HTML5_plz(xmlDoc* doc);

// I KNOW I created this before...
xmlChar* findPropCsux(xmlNode* o, xmlChar* name, size_t len);
#define findProp(a,b) findPropCsux(a,b,sizeof(b)-1)

// find the next actual element, if the current is a text node or something.
// use like next = nextE(cur->next);
xmlNode* nextE(xmlNode* e);
// where the hell did this go?
void html_dump_to_fd(int fd, xmlDoc* doc);

/* To walk a tree,
   1) next, next, next, ... until next is null
   2) if child is not null, go down, then goto (1)
   3) next is null, child is null, so go parent then...
   4) if prev is not null, prev, child, then goto (1)
   5) next, child, prev is null, go parent
 */
