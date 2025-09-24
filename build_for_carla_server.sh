#!/bin/bash -e
# Build lanelet lib with libcxx to be used by carla server plugins (CarlaTools)

#Option: Debug, Release, RelWithDebInfo and MinSizeRel
BUILD_TYPE=Release

if [ "${CARLA_ROOT}" == '' ]; then
  echo "Error: CARLA_ROOT environment is not set! please set it to the CARLA location!"
elif [ -f ${CARLA_ROOT}/Util/BuildTools/Vars.mk ]; then
  CURDIR=${CARLA_ROOT}
  source ${CARLA_ROOT}/Util/BuildTools/Vars.mk
  unset CURDIR

  echo "Use CARLA_ROOT: ${CARLA_ROOT}"
  echo "Use LIBCARLA_INSTALL_SERVER_FOLDER: ${LIBCARLA_INSTALL_SERVER_FOLDER}"
  echo "Use CARLA_BUILD_FOLDER: ${CARLA_BUILD_FOLDER}"
else
  echo "Error: Wrong CARLA_ROOT(${CARLA_ROOT}) setting! Can not find :${CARLA_ROOT}/Util/BuildTools/Vars.mk"
fi

# install our version to build folder and copy the required .so to ${LIBCARLA_INSTALL_SERVER_FOLDER}
INSTALL_DIR=${CARLA_BUILD_FOLDER}/lanelet-1.2.2-server-install

rm -rf build ${INSTALL_DIR}
mkdir -p build
cd build

# set dependencies search dir
PKG_PATH="${CARLA_BUILD_FOLDER}/boost-1.86.0-server-install/lib/cmake"
PKG_PATH="${CARLA_BUILD_FOLDER}/geographiclib-2.5.2-server-install/lib/cmake:${PKG_PATH}"
PKG_PATH="${CARLA_BUILD_FOLDER}/pugixml-1.15-server-install/lib/cmake:${PKG_PATH}"
PKG_PATH="${CARLA_BUILD_FOLDER}/eigen-3.4.1-server-install/share/eigen3/cmake:${PKG_PATH}"

echo PKG_PATH="${PKG_PATH}"

VERBOSE=1 CMAKE_PREFIX_PATH="${PKG_PATH}" cmake -DCMAKE_TOOLCHAIN_FILE=./LibCppToolChain.cmake \
 -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
 -DCMAKE_INSTALL_PREFIX=${INSTALL_DIR} \
 -DBUILD_SHARED_LIBS=YES \
 ..

VERBOSE=1 cmake --build .
VERBOSE=1 cmake --install .

# need by lanelet lib
echo copy ${INSTALL_DIR}/lib/lib* to ${LIBCARLA_INSTALL_SERVER_FOLDER}/lib/
cp ${INSTALL_DIR}/lib/lib* ${LIBCARLA_INSTALL_SERVER_FOLDER}/lib/