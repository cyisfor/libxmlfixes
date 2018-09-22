cmake_minimum_required(VERSION 3.0)
project(story-generator VERSION 0.1)

include(ExternalProject)

ExternalProject_Add(libxml2
	DOWNLOAD_COMMAND "rsync -aPv --exclude .git ${CMAKE_CURRENT_SOURCE_DIR}/libxml2 libxml2"
	)

add_library(libxmlfixes
	wanted_tags.gen.c
	src/libxmlfixes.c
	src/selectors.c)

add_custom_command(
	OUTPUT wanted_tags.gen.c
	COMMAND make-wanted . <${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted
	BYPRODUCTS wanted_tags.gen.h
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	DEPENDS tags.wanted)
	
