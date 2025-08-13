CMAKE_MINIMUM_REQUIRED(VERSION 3.22)

project(lanelet2)

# only following sub projects have been converted to general CMake script,
# without the dependency on ROS/Colcon/Mrt build system which will link to
# the ROS prebuilt libraries.
# With general plain CMake script, we can switch to carla toolchain to build
# lanelet for the need of carla ditital twin tool.
add_subdirectory(lanelet2_core)
add_subdirectory(lanelet2_io)
add_subdirectory(lanelet2_projection)
