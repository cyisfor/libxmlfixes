import sys,re

class pat:
	undef = re.compile("^#undef (.*)")

print(sys.stdin.readline())
print("")

for comment in sys.stdin:
	undef = sys.stdin.readline()
	name = pat.undef.match(undef).group(1)
	comment = comment[2:-2].strip()
	print("set("+name+" CACHE BOOL OFF "+repr(comment)+")")
	
