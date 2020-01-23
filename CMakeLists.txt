cmake_minimum_required(VERSION 3.14)
project(libxmlfixes VERSION 0.1)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/add_module")
include(AddModule)

add_module(libxml2
  GIT 84183e361fef43608ca4c4b0e388db304c92d6b9
  file:///home/repo/libxml2
  git@github.com:cyisfor/libxml2.git
  https://github.com/cyisfor/libxml2.git)

add_library(xmlfixes
	wanted_tags.gen.c
	wanted_tags.gen.h
	src/libxmlfixes.c
	src/selectors.c)
add_dependencies(xmlfixes xml)

target_link_libraries(xmlfixes PUBLIC xml)
target_include_directories(xmlfixes PUBLIC
  "${MODULE_BIN_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/src"
  "${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include"
  "${CMAKE_CURRENT_BINARY_DIR}"
  "${CMAKE_CURRENT_BINARY_DIR}/libxml2"
  "${CMAKE_CURRENT_BINARY_DIR}/libxml2/include")

add_custom_command(
	OUTPUT wanted_tags.gen.c wanted_tags.gen.h
	COMMAND make-wanted . <"${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted"
	DEPENDS make-wanted "${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted")
	
add_executable(make-wanted
	src/make-wanted.c)

add_executable(test-xmlfixes
	src/test.c)

target_link_libraries(test-xmlfixes PUBLIC xmlfixes)
target_include_directories(test-xmlfixes PUBLIC
	"${CMAKE_CURRENT_SOURCE_DIR}/libxml2/include"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2"
	"${CMAKE_CURRENT_BINARY_DIR}/libxml2/include")
