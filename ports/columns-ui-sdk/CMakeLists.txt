project(columns-ui-sdk)
cmake_minimum_required(VERSION 3.23)

find_package(unofficial-foobar2000-sdk CONFIG REQUIRED)
find_path(WTL_INCLUDE_DIRS "atlapp.h")

file(GLOB columns_SOURCES "*.cpp")
file(GLOB columns_HEADERS "*.h")
add_library(columns_ui_sdk STATIC ${columns_SOURCES})
target_compile_definitions(columns_ui_sdk PUBLIC NOMINMAX UNICODE _UNICODE)
target_compile_features(columns_ui_sdk PUBLIC cxx_std_20)
target_include_directories(columns_ui_sdk INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(columns_ui_sdk
    PUBLIC
	# unofficial::foobar2000-sdk::foobar2000_component_client
	unofficial::foobar2000-sdk::helpers
	unofficial::foobar2000-sdk::pfc
	unofficial::foobar2000-sdk::SDK
	unofficial::foobar2000-sdk::shared
)
target_sources(columns_ui_sdk PUBLIC FILE_SET HEADERS FILES ${columns_HEADERS})

install(TARGETS columns_ui_sdk
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    FILE_SET HEADERS DESTINATION include
)