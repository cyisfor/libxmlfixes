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
#define findProp(a) findPropCsux(a,sizeof(a)-1)
