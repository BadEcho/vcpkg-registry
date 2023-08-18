set(GIT_URL "https://github.com/Chlumsky/msdf-atlas-gen.git")
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${PORT})

if(NOT EXISTS "${SOURCE_PATH}/.git")
	message(STATUS "Cloning and fetching submodules")
	vcpkg_execute_required_process(
	  COMMAND ${GIT} clone --recurse-submodules ${GIT_URL} ${SOURCE_PATH}
	  WORKING_DIRECTORY ${DOWNLOADS}
	  LOGNAME clone
	)
endif()

vcpkg_check_features(
    OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        openmp MSDFGEN_USE_OPENMP
        geometry-preprocessing MSDFGEN_USE_SKIA
        tools MSDFGEN_BUILD_STANDALONE
    INVERTED_FEATURES
        extensions MSDFGEN_CORE_ONLY
)

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"  
  PREFER_NINJA
  OPTIONS -DMSDF_ATLAS_INSTALL=ON 
          -DMSDF_ATLAS_BUILD_STANDALONE=OFF
          -DMSDFGEN_USE_VCPKG=ON
          -DMSDFGEN_VCPKG_FEATURES_SET=ON
                  ${FEATURE_OPTIONS}
  MAYBE_UNUSED_VARIABLES
      MSDFGEN_VCPKG_FEATURES_SET
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/LICENSE.txt"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)