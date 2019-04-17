cmake_minimum_required(VERSION 3.0)
project(libxmlfixes VERSION 0.1)

add_subdirectory(libxml2)

add_library(xmlfixes
	wanted_tags.gen.c
	wanted_tags.gen.h
	src/libxmlfixes.c
	src/selectors.c)
add_dependencies(xmlfixes xml)

target_link_libraries(xmlfixes PUBLIC xml)
target_include_directories(xmlfixes PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2/include")

add_custom_command(
	OUTPUT wanted_tags.gen.c wanted_tags.gen.h
	COMMAND make-wanted . <${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	DEPENDS make-wanted tags.wanted)
	
add_executable(make-wanted
	src/make-wanted.c)

add_executable(test-xmlfixes
	src/test.c)

target_link_libraries(test-xmlfixes PUBLIC xmlfixes)
target_include_directories(test-xmlfixes PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2/include")
