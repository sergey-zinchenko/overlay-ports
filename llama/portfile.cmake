vcpkg_from_github(OUT_SOURCE_PATH SOURCE_PATH
        REPO "ggerganov/llama.cpp"
        REF b2589
        HEAD_REF master
        SHA512 7708d1c1af7af95e5de9865fe82b4f325389fe78891e5160b2579baaabb3757fcd72378927d98b81b7cdd0f34c296588985dd45bb322570f39f0d3a13d006b71
        PATCHES
          fix-packaging.patch
)

vcpkg_find_acquire_program(PKGCONFIG)
get_filename_component(PKGCONFIG_DIR "${PKGCONFIG}" DIRECTORY)
vcpkg_add_to_path("${PKGCONFIG_DIR}")
vcpkg_find_acquire_program(GIT)
get_filename_component(GIT_PATH ${GIT} DIRECTORY)
vcpkg_add_to_path(PREPEND "${GIT_PATH}")


vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
        FEATURES
        openblass LLAMA_BLAS
)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND ADDITIONAL_FLAGS "-DLLAMA_STATIC=ON")
endif()


vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS
        ${FEATURE_OPTIONS}
        ${ADDITIONAL_FLAGS}
        -DLLAMA_AVX2=ON
        -DLLAMA_FMA=ON
        -DLLAMA_NATIVE=OFF
        -DLLAMA_BLAS_VENDOR=OpenBLAS
        -DBUILD_SHARED_LIBS=ON
        -DLLAMA_BUILD_TESTS=OFF
        -DLLAMA_BUILD_EXAMPLES=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Llama)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")