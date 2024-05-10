set(GIT_URL "https://github.com/Chlumsky/msdf-atlas-gen.git")
set(GIT_REV "cad221afcd438842ed73814cc1ee1c3a7f4fe300")
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/${PORT})
set(PORT_DEBUG ON)

# option(MSVC_DYNAMIC_RUNTIME "Whether to use dynamic CRT linking or not" OFF)

if(NOT EXISTS "${SOURCE_PATH}/.git")
	message(STATUS "Cloning and fetching submodules")
	vcpkg_execute_required_process(
	  COMMAND ${GIT} clone --recurse-submodules ${GIT_URL} ${SOURCE_PATH}
	  WORKING_DIRECTORY ${DOWNLOADS}
	  LOGNAME clone
	)

  #message(STATUS "Checkout revision ${GIT_REV}")
  #vcpkg_execute_required_process(
    #COMMAND ${GIT} checkout ${GIT_REV}
    #WORKING_DIRECTORY ${SOURCE_PATH}
    #LOGNAME checkout
  #)
endif()

message(STATUS "This is VCPKG_CRT_LINKAGE: ${VCPKG_CRT_LINKAGE}")

if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
  set(MSVC_DYNAMIC_RUNTIME ON)
else()
  set(MSVC_DYNAMIC_RUNTIME OFF)
endif()

message(STATUS "This is MSVC_DYNAMIC_RUNTIME: ${MSVC_DYNAMIC_RUNTIME}")

vcpkg_cmake_configure(
  SOURCE_PATH "${SOURCE_PATH}"  
  PREFER_NINJA
  OPTIONS -DMSDF_ATLAS_INSTALL=ON 
          -DMSDF_ATLAS_BUILD_STANDALONE=OFF
          -DMSDF_ATLAS_DYNAMIC_RUNTIME=${MSVC_DYNAMIC_RUNTIME}
)
vcpkg_cmake_install()
vcpkg_cmake_config_fixup(CONFIG_PATH "lib/cmake/${PORT}")

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")

file(
  INSTALL "${SOURCE_PATH}/LICENSE.txt"
  DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}"
  RENAME copyright)