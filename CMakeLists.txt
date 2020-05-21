CMAKE_MINIMUM_REQUIRED (VERSION 3.10.2)
PROJECT (mini-era)

#find_package(OpenCV REQUIRED)
#include_directories(${OpenCV_INCLUDE_DIRS})

INCLUDE (cmake/ir.cmake)

INCLUDE_DIRECTORIES (fft/fft-1d)
ADD_SUBDIRECTORY (fft)
ADD_SUBDIRECTORY (radar)
ADD_SUBDIRECTORY (viterbi)

SET (SRCS
     kernels_api.c
     main.c
     read_trace.c)

SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I/usr/include/python3.6m")
ADD_EXECUTABLE (miniera sim_environs.c ${SRCS})
TARGET_LINK_LIBRARIES (miniera fft-1d radar viterbi python3.6m)

ADD_IR_TARGETS ("${SRCS}" IRTS)
SET (IR_TARGETS "${IRTS} ${IR_TARGETS}")

# target to build all ir
ADD_CUSTOM_TARGET (ir
                   COMMAND ${CMAKE_SOURCE_DIR}/ir.sh ${IR_TARGETS})
