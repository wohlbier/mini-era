#SET (INPUT_SIZE SMALL)
#SET (INPUT_SIZE MEDIUM)
SET (INPUT_SIZE LARGE)
SET (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DINPUT_SIZE=INPUT_SIZE_${INPUT_SIZE}")

SET (LIB_SRCS
  fft.c
  octave.c
  timer.c)

ADD_LIBRARY (fft-1d ${LIB_SRCS})
TARGET_LINK_LIBRARIES (fft-1d m)

ADD_IR_TARGETS ("${LIB_SRCS}" IRTS IRFS)
SET (IR_TARGETS "${IRTS};${IR_TARGETS}" PARENT_SCOPE)
SET (IR_FILES "${IRFS};${IR_FILES}" PARENT_SCOPE)

ADD_FP_TARGETS ("${LIB_SRCS}" FPTS)
SET (FP_TARGETS "${FPTS};${FP_TARGETS}" PARENT_SCOPE)
