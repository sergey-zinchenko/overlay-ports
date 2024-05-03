vcpkg_from_github(OUT_SOURCE_PATH SOURCE_PATH
        REPO "ggerganov/llama.cpp"
        REF b2783
        HEAD_REF master
        SHA512 aef886f8c66ba0bb958f048e350deb65cf9587a105caa59c11089140e6f013e131f88df7d762273457275eb731448e32d7c79fb2dbe8b83509fc8cd92b0df164
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
        openblas LLAMA_BLAS
)

if (LLAMA_BLAS)
    list(APPEND ADDITIONAL_FLAGS "-DLLAMA_BLAS_VENDOR=OpenBLAS")
endif ()

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    list(APPEND ADDITIONAL_FLAGS "-DLLAMA_STATIC=ON")
endif ()

vcpkg_cmake_configure(
        SOURCE_PATH "${SOURCE_PATH}"
        OPTIONS
        ${FEATURE_OPTIONS}
        ${ADDITIONAL_FLAGS}
        -DLLAMA_AVX2=ON
        -DLLAMA_FMA=ON
        -DLLAMA_NATIVE=OFF
        -DBUILD_SHARED_LIBS=ON
        -DLLAMA_BUILD_TESTS=OFF
        -DLLAMA_BUILD_EXAMPLES=OFF
)

vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Llama)

if (VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/bin" "${CURRENT_PACKAGES_DIR}/debug/bin")
endif ()

vcpkg_copy_pdbs()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")
vcpkg_install_copyright(FILE_LIST "${SOURCE_PATH}/LICENSE")