cmake_minimum_required(VERSION 3.0)
project(libxmlfixes VERSION 0.1)

add_subdirectory(libxml2)

add_library(xmlfixes
	wanted_tags.gen.c
	src/libxmlfixes.c
	src/selectors.c)
add_dependencies(xmlfixes xml)

target_link_libraries(xmlfixes PRIVATE libxml.la)
target_include_directories(xmlfixes PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2/include")

add_custom_command(
	OUTPUT wanted_tags.gen.c
	COMMAND make-wanted . <${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted
	BYPRODUCTS wanted_tags.gen.h
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	DEPENDS make-wanted tags.wanted)
	
add_executable(make-wanted
	src/make-wanted.c)
