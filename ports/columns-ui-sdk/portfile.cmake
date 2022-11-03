vcpkg_from_git(
    OUT_SOURCE_PATH SOURCE_PATH
    URL https://github.com/reupen/columns_ui-sdk
    REF f57c12948ee28a8b108194574f1d08d9fe4a2237
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
)

vcpkg_install_cmake()
vcpkg_copy_pdbs()

vcpkg_cmake_config_fixup(PACKAGE_NAME unofficial-${PORT} CONFIG_PATH share/unofficial-${PORT})

configure_file(${SOURCE_PATH}/LICENCE ${CURRENT_PACKAGES_DIR}/share/${PORT}/copyright COPYONLY)