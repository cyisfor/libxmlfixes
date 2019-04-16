cmake_minimum_required(VERSION 3.0)
project(libxmlfixes VERSION 0.1)

configure_file(libxml2/include/libxml/xmlversion.h.in libxml/xmlversion.h)

set(WITH_TRIO OFF CACHE BOOL "DERP")
set(WITH_THREADS OFF CACHE BOOL "DERP")
set(WITH_THREAD_ALLOC OFF CACHE BOOL "DERP")
set(WITH_TREE ON CACHE BOOL "DERP")
set(WITH_OUTPUT ON CACHE BOOL "DERP")
set(WITH_PUSH ON CACHE BOOL "DERP")
set(WITH_READER ON CACHE BOOL "DERP")
set(WITH_WRITER ON CACHE BOOL "DERP")
set(WITH_PATTERN ON CACHE BOOL "DERP")
set(WITH_SAX1 OFF CACHE BOOL "DERP")
set(WITH_FTP OFF CACHE BOOL "DERP")
set(WITH_HTTP OFF CACHE BOOL "DERP")
set(WITH_VALID OFF CACHE BOOL "DERP")
set(WITH_HTML ON CACHE BOOL "DERP")
set(WITH_LEGACY OFF CACHE BOOL "DERP")
set(WITH_C14N OFF CACHE BOOL "DERP")
set(WITH_CATALOG OFF CACHE BOOL "DERP")
set(WITH_DOCB OFF CACHE BOOL "DERP")
set(WITH_XPATH ON CACHE BOOL "DERP")
set(WITH_XPTR ON CACHE BOOL "DERP")
set(WITH_XINCLUDE OFF CACHE BOOL "DERP")
set(WITH_ICONV ON CACHE BOOL "DERP")
set(WITH_ICU ON CACHE BOOL "DERP")
set(WITH_ISO8859X OFF CACHE BOOL "DERP")
set(WITH_DEBUG OFF CACHE BOOL "DERP")
set(WITH_MEM_DEBUG OFF CACHE BOOL "DERP")
set(WITH_RUN_DEBUG OFF CACHE BOOL "DERP")
set(WITH_REGEXPS OFF CACHE BOOL "Whether Unicode is compiled in?")
set(WITH_SCHEMAS OFF CACHE BOOL "DERP")
set(WITH_SCHEMATRON OFF CACHE BOOL "DERP")
set(WITH_MODULES OFF CACHE BOOL "DERP")
set(WITH_ZLIB OFF CACHE BOOL "DERP")
set(WITH_LZMA OFF CACHE BOOL "DERP")

set(LIBXML_VERSION_EXTRA "derp" CACHE STRING "version extra")
set(LIBXML_VERSION_NUMBER "1.0" CACHE STRING "version number")

add_library(mylibxml
	libxml/xmlversion.h
	libxml2/xmlwriter.c)

target_include_directories(mylibxml PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include" "${CMAKE_CURRENT_BINARY_DIR}")

add_library(libxmlfixes
	wanted_tags.gen.c
	src/libxmlfixes.c
	src/selectors.c)
add_dependencies(libxmlfixes mylibxml)
target_include_directories(libxmlfixes PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include" "${CMAKE_CURRENT_BINARY_DIR}")
target_link_libraries(libxmlfixes mylibxml.la)

add_custom_command(
	OUTPUT wanted_tags.gen.c
	COMMAND make-wanted . <${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted
	BYPRODUCTS wanted_tags.gen.h
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	DEPENDS make-wanted tags.wanted)
	

add_executable(make-wanted
	src/make-wanted.c)
