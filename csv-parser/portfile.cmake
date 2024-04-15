vcpkg_from_github(
        OUT_SOURCE_PATH SOURCE_PATH
        REPO vincentlaucsb/csv-parser
        REF "2.2.0"
        SHA512 e2b3913eae0c496c72139fb2236743bdcd54e3b316f0b4d52eda4412e00a3fe62df3a6c73f619ec025a829c51ef639db9b0027c9b8a98c0e0bf8070475c80246
        HEAD_REF master
        PATCHES
        fix-packaging.patch
)

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND ADDITIONAL_FLAGS "-DBUILD_SHARED_LIBS=ON")
endif ()

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS
        ${ADDITIONAL_FLAGS}
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/csv-parser)

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")
