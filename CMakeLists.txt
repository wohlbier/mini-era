CMAKE_MINIMUM_REQUIRED (VERSION 3.10.2)
PROJECT (mini-era)

#find_package(OpenCV REQUIRED)
#include_directories(${OpenCV_INCLUDE_DIRS})

INCLUDE (cmake/llvm.cmake)

INCLUDE_DIRECTORIES (fft/fft-1d)
ADD_SUBDIRECTORY (fft)
ADD_SUBDIRECTORY (radar)
ADD_SUBDIRECTORY (viterbi)

SET (SRCS
  kernels_api.c
  main.c
  read_trace.c)

SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -I/usr/include/python3.6m")
ADD_EXECUTABLE (mini-era sim_environs.c ${SRCS})
TARGET_LINK_LIBRARIES (mini-era fft-1d radar viterbi python3.6m)

ADD_IR_TARGETS ("${SRCS}" IRTS IRFS)
SET (IR_TARGETS "${IRTS};${IR_TARGETS}")
STRING (REPLACE ";" " " IR_TARGETS "${IR_TARGETS}") # put spaces back for ir.sh
SET (IR_FILES "${IRFS};${IR_FILES}")

ADD_FP_TARGETS ("${SRCS}" FPTS)
SET (FP_TARGETS "${FPTS};${FP_TARGETS}")
STRING (REPLACE ";" " " FP_TARGETS "${FP_TARGETS}") # put spaces back for ir.sh

# target to build all ir
ADD_CUSTOM_TARGET (ir
  COMMAND ${CMAKE_SOURCE_DIR}/ir.sh ${IR_TARGETS})

# link all ir files
ADD_CUSTOM_TARGET (mini-era.ir
  COMMAND
  llvm-link -S ${IR_FILES} -o ${CMAKE_BINARY_DIR}/mini-era.ir
  DEPENDS ir)

# target to build all fp
ADD_CUSTOM_TARGET (fp
  COMMAND ${CMAKE_SOURCE_DIR}/ir.sh ${FP_TARGETS}
  DEPENDS ir)

# add target for call graph files
GV_TARGET(mini-era)

# add targets for swhw levels
SET (LEVEL 6)
FOREACH (l RANGE ${LEVEL})
  SW_HW_AREA_TGT (mini-era ${l})
ENDFOREACH ()
ADD_CUSTOM_TARGET (sw_hw_area
  COMMAND ${CMAKE_SOURCE_DIR}/swhw.sh ${LEVEL}
  DEPENDS gv)
