cmake_minimum_required(VERSION 3.0)
project(story-generator VERSION 0.1)

include(ExternalProject)

ExternalProject_Add(libxml2
	UPDATE_COMMAND rsync -aPv --exclude .git ${CMAKE_CURRENT_SOURCE_DIR}/libxml2/ ./
	DOWNLOAD_DIR ${CMAKE_CURRENT_SOURCE_DIR}
	DOWNLOAD_COMMAND git submodule update --init --recursive --checkout
	CONFIGURE_COMMAND ../libxml2/configure --prefix=${CMAKE_PREFIX_PATH} --without-python
	BUILD_COMMAND make
	)

add_library(libxmlfixes
	wanted_tags.gen.c
	src/libxmlfixes.c
	src/selectors.c)
target_link_libraries(libxmlfixes libxml2/libxml2.la)

add_custom_command(
	OUTPUT wanted_tags.gen.c
	COMMAND make-wanted . <${CMAKE_CURRENT_SOURCE_DIR}/tags.wanted
	BYPRODUCTS wanted_tags.gen.h
	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
	DEPENDS tags.wanted)
	
