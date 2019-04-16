import sys,re

class pat:
	undef = re.compile("^#undef (.*)")
	comment = re.compile(r'/\* *(.*?) *\*/')
	header = re.compile("HAVE_(.*?)_H")
	function = re.compile("HAVE_(.*)")
#print(sys.stdin.readline())
#print("")

things = {}

for comment in sys.stdin:
	m = pat.comment.match(comment)
	if not m: continue
	comment = m.group(1)
	undef = sys.stdin.readline()
	m = pat.undef.match(undef)
	if not m:
		continue
	things[m.group(1)] = comment

print("INCLUDE (CheckIncludeFiles)")
print("INCLUDE (CheckFunctionExists)")
	
for name,comment in sorted(things.items()):
	m = pat.header.search(name)
	if m:
		header = m.group(1).lower()+".h"
		print("CHECK_INCLUDE_FILES("+header+" "+name+")")
	else:
		m = pat.function.search(name)
		if m:
			function = m.group(1).lower()
			print("CHECK_FUNCTION_EXISTS("+function+" "+name+")")
		else:
			print("set("+name+" CACHE BOOL ON "+repr(comment)+")")
	
print('configure_file("libxml2/config.h.in" "config.h")')
