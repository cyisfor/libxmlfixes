import sys,re

class pat:
	undef = re.compile("^#undef (.*)")
	comment = re.compile(r'/\* *(.*?) *\*/')
print(sys.stdin.readline())
print("")

for comment in sys.stdin:
	m = pat.comment.match(comment)
	if not m: continue
	comment = m.group(1)
	undef = sys.stdin.readline()
	m = pat.undef.match(undef)
	if not m:
		print('undef',repr(undef))
		continue
	name = m.group(1)
	comment = comment[2:-2].strip()
	print("set("+name+" CACHE BOOL OFF "+repr(comment)+")")
	
