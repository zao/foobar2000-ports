vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/zao/foobar2000-SDK
    REF f27a676212ef4c1b16638a17302ff31b0f95b4f3
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-${PORT} CONFIG_PATH share/unofficial-${PORT})

configure_file(${SOURCE_PATH}/sdk-license.txt ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)