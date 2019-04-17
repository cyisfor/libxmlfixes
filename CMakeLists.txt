cmake_minimum_required(VERSION 3.0)
project(libxmlfixes VERSION 0.1)

add_library(libxml
	libxml2/include/libxml/xmlversion.h
	libxml2/config.h
	libxml2/xmlwriter.c)

add_custom_command(
	OUTPUT
	libxml2
	COMMAND file(MAKE_DIRECTORY libxml2))
add_custom_command(
	OUTPUT
	libxml2/include/libxml/xmlversion.h
	libxml2/config.h
	WORKING_DIRECTORY libxml2
	COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/libxml2/configure
	ARGS
	--without-modules
	--without-xinclude
	--without-valid
	--without-threads
	--without-schematron
	--without-schemas
	--without-sax1
	--without-regexps
	--without-python
	--without-pattern
	--without-legacy
	--without-ftp
	--without-http
	--without-debug
	--without-catalog
	--disable-ipv6
	--disable-dependency-tracking
	--disable-shared
	--disable-static
	MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/libxml2/configure
  DEPENDS libxml2)


target_include_directories(libxml PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2/include")

add_library(libxmlfixes
	wanted_tags.gen.c
	src/libxmlfixes.c
	src/selectors.c)
add_dependencies(libxmlfixes libxml)
	
target_link_libraries(libxmlfixes libxml.la)

add_custom_command(
	OUTPUT wanted_tags.gen.c
	COMMAND make-wanted . <${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted
	BYPRODUCTS wanted_tags.gen.h
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	DEPENDS make-wanted tags.wanted)
	

add_executable(make-wanted
	src/make-wanted.c)
