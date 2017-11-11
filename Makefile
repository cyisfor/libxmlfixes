include coolmake/head.mk
include main.mk
include coolmake/tail.mk

git-tools/funcs.sh:
	git submodule update --init

coolmake/head.mk: coolmake/tail.mk coolmake/top.mk | libxml2/include
	sh setup.sh
coolmake/tail.mk coolmake/top.mk libxml2/include: ;

all: libxmlfixes.la
