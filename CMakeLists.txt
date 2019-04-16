cmake_minimum_required(VERSION 3.0)
project(libxmlfixes VERSION 0.1)

configure_file(libxml2/include/libxml/xmlversion.h.in libxml/xmlversion.h)

add_library(mylibxml
	libxml/xmlversion.h
	libxml2/xmlwriter.c)

target_include_directories(mylibxml PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include" "${CMAKE_CURRENT_BUILD_DIR}")

add_library(libxmlfixes
	wanted_tags.gen.c
	src/libxmlfixes.c
	src/selectors.c)
add_dependencies(libxmlfixes mylibxml)
target_include_directories(libxmlfixes PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include" "${CMAKE_CURRENT_BUILD_DIR}")
target_link_libraries(libxmlfixes mylibxml.la)

add_custom_command(
	OUTPUT wanted_tags.gen.c
	COMMAND make-wanted . <${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted
	BYPRODUCTS wanted_tags.gen.h
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	DEPENDS make-wanted tags.wanted)
	

add_executable(make-wanted
	src/make-wanted.c)
