project(foobar2000-sdk)
cmake_minimum_required(VERSION 3.23)

find_path(WTL_INCLUDE_DIRS "atlapp.h")

file(GLOB pfc_SOURCES "pfc/*.cpp")
file(GLOB pfc_HEADERS "pfc/*.h")
list(REMOVE_ITEM pfc_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/pfc/pfc-fb2k-hooks.cpp")
add_library(pfc STATIC ${pfc_SOURCES})
target_compile_definitions(pfc PUBLIC UNICODE _UNICODE)
target_compile_features(pfc PUBLIC cxx_std_17)
target_include_directories(pfc INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>
    $<INSTALL_INTERFACE:include>
)
target_sources(pfc PUBLIC FILE_SET HEADERS FILES ${pfc_HEADERS})

file(GLOB libPPUI_SOURCES "libPPUI/*.cpp")
file(GLOB libPPUI_HEADERS "libPPUI/*.h")
add_library(libPPUI STATIC ${libPPUI_SOURCES})
target_include_directories(libPPUI PUBLIC
    $<BUILD_INTERFACE:${WTL_INCLUDE_DIRS}>
)
target_link_libraries(libPPUI PUBLIC pfc)
target_sources(libPPUI PUBLIC FILE_SET HEADERS FILES ${libPPUI_HEADERS})

file(GLOB SDK_SOURCES "foobar2000/SDK/*.cpp")
file(GLOB SDK_HEADERS "foobar2000/SDK/*.h")
add_library(SDK STATIC ${SDK_SOURCES})
target_include_directories(SDK PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/foobar2000>
    $<INSTALL_INTERFACE:include/foobar2000>
)
target_link_libraries(SDK PUBLIC pfc)
target_sources(SDK PUBLIC FILE_SET HEADERS FILES ${SDK_HEADERS})

file(GLOB helpers_SOURCES "foobar2000/helpers/*.cpp")
file(GLOB helpers_HEADERS "foobar2000/helpers/*.h")
add_library(helpers STATIC ${helpers_SOURCES})
target_include_directories(helpers PUBLIC
    $<BUILD_INTERFACE:${WTL_INCLUDE_DIRS}>
)
target_link_libraries(helpers PUBLIC SDK)
target_sources(helpers PUBLIC FILE_SET HEADERS FILES ${helpers_HEADERS})

file(GLOB foobar2000_component_client_SOURCES "foobar2000/foobar2000_component_client/*.cpp")
add_library(foobar2000_component_client STATIC ${foobar2000_component_client_SOURCES})
target_link_libraries(foobar2000_component_client PUBLIC SDK)

file(GLOB shared_HEADERS "foobar2000/shared/*.h")
add_library(shared INTERFACE)

set(shared_LIBRARY "${CMAKE_CURRENT_SOURCE_DIR}/foobar2000/shared/shared-${CMAKE_VS_PLATFORM_NAME}.lib")
target_link_libraries(shared INTERFACE ${shared_LIBRARY})
target_sources(shared PUBLIC FILE_SET HEADERS FILES ${shared_HEADERS})

file(GLOB foo_sample_SOURCES "foobar2000/foo_sample/*.cpp" "foobar2000/foo_sample/*.h" "foobar2000/foo_sample/*.rc")
add_library(foo_sample SHARED ${foo_sample_SOURCES})
target_link_libraries(foo_sample
    PRIVATE
    foobar2000_component_client
    helpers
    libPPUI
    pfc
    SDK
    shared
)

install(FILES ${shared_LIBRARY} DESTINATION lib)

install(TARGETS foobar2000_component_client helpers libPPUI pfc SDK shared
    EXPORT unofficial-foobar2000-sdk-targets
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib
    FILE_SET HEADERS DESTINATION include CONFIGURATIONS Release
)

install(EXPORT unofficial-foobar2000-sdk-targets
    NAMESPACE unofficial::foobar2000-sdk::
    FILE unofficial-foobar2000-sdk-targets.cmake
    DESTINATION share/unofficial-foobar2000-sdk
)

file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/unofficial-foobar2000-sdk-config.cmake "include(\${CMAKE_CURRENT_LIST_DIR}/unofficial-foobar2000-sdk-targets.cmake)")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/unofficial-foobar2000-sdk-config.cmake DESTINATION share/unofficial-foobar2000-sdk)