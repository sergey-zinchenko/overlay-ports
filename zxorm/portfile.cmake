vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO crabmandable/zxorm
        REF "0.1.3"
        SHA512 f904d091c008827f51e4da3df54a98d95c76981833f95d46a9908cdbc2a3895e451e060bb86382a9506fc51ce83c330849f909db3a63ff0fe9a7a2520e01a752
        HEAD_REF master
        PATCHES
        fix-packaging.patch
)


vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
)

vcpkg_cmake_install()
#vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/zxorm)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE.txt")
