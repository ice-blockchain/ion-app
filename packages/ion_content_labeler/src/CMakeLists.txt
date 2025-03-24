# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

project(ion_content_labeler_library VERSION 0.0.1 LANGUAGES C)

add_library(ion_content_labeler SHARED
  "ion_content_labeler.c"
)

set_target_properties(ion_content_labeler PROPERTIES
  PUBLIC_HEADER ion_content_labeler.h
  OUTPUT_NAME "ion_content_labeler"
)

target_compile_definitions(ion_content_labeler PUBLIC DART_SHARED_LIB)

if (ANDROID)
  # Support Android 15 16k page size
  target_link_options(ion_content_labeler PRIVATE "-Wl,-z,max-page-size=16384")
endif()
