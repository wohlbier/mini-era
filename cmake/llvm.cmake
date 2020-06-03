# get include dirs
FUNCTION (GET_INCS cflags)
  GET_PROPERTY (dirs
    DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    PROPERTY INCLUDE_DIRECTORIES)
  FOREACH (d ${dirs})
    SET (inc_dirs "-I${d} ${inc_dirs}")
  ENDFOREACH ()
  SET (cfs "${inc_dirs} ${CMAKE_C_FLAGS}")
  STRING (REPLACE " " ";" cfs ${cfs})
  SET (${cflags} "${cfs}" PARENT_SCOPE)
ENDFUNCTION ()

# adds target for IR.
FUNCTION (IR_TARGET SRCS IRFS)
  GET_INCS(cflags)
  FOREACH (f ${SRCS})
    STRING (REPLACE ".c" "" base ${f})
    ADD_CUSTOM_TARGET (${base}.ir
      COMMAND clang -S -emit-llvm
      ${cflags}
      ${CMAKE_CURRENT_SOURCE_DIR}/${f}
      -o ${CMAKE_CURRENT_BINARY_DIR}/${base}.ir)
    SET (irfl "${irfl};${CMAKE_CURRENT_BINARY_DIR}/${base}.ir")
  ENDFOREACH ()
  SET (${IRFS} "${irfl}" PARENT_SCOPE)
ENDFUNCTION ()

# adds target for fp
FUNCTION (FP_TARGET SRCS)
  FOREACH (f ${SRCS})
    STRING (REPLACE ".c" "" base ${f})
    ADD_CUSTOM_TARGET (${base}.fp
      COMMAND
      $ENV{LLVM_BIN_DIR}/opt -block-freq -analyze
      ${cflags}
      ${CMAKE_CURRENT_BINARY_DIR}/${base}.ir
      -o ${CMAKE_CURRENT_BINARY_DIR}/${base}.fp)
  ENDFOREACH ()
ENDFUNCTION ()

# adds target for gv
FUNCTION (GV_TARGET PROG)
  ADD_CUSTOM_TARGET (gv
    COMMAND
    $ENV{LLVM_BIN_DIR}/opt -load
    $ENV{LLVM_BIN_DIR}/lib/AccelSeekerIO.so
    -AccelSeekerIO -stats > /dev/null
    ${CMAKE_CURRENT_BINARY_DIR}/${PROG}.ir
    DEPENDS ${PROG}.ir)
ENDFUNCTION ()

# adds targets for SW, HW, and AREA estimation bottom up
FUNCTION (SW_HW_AREA_TGT PROG LEVEL)
  ADD_CUSTOM_TARGET (sw_hw_area_${LEVEL}
    COMMAND
    $ENV{LLVM_BIN_DIR}/opt -load
    $ENV{LLVM_BIN_DIR}/lib/AccelSeeker.so
    -AccelSeeker -stats > /dev/null
    ${CMAKE_CURRENT_BINARY_DIR}/${PROG}.ir)
  # depend responsibility of caller
ENDFUNCTION()

# helpers

FUNCTION (X_TO_Y dotX dotY Xs Ys)
  SET (l "")
  FOREACH (f ${Xs})
    STRING (REPLACE ${dotX} ${dotY} t ${f})
    SET (l "${l};${t}")
  ENDFOREACH ()
  SET (${Ys} "${l}" PARENT_SCOPE)
ENDFUNCTION ()

FUNCTION (ADD_IR_TARGETS SRCS IR_TARGETS IR_FILES)
  IF (CMAKE_C_COMPILER_ID STREQUAL Clang)
    STRING (REPLACE " " ";" SRCS "${SRCS}")
    IR_TARGET ("${SRCS}" IRFS)
    X_TO_Y (".c" ".ir" "${SRCS}" IRTS)
    SET (${IR_TARGETS} "${IRTS}" PARENT_SCOPE)
    SET (${IR_FILES} "${IRFS}" PARENT_SCOPE)
  ENDIF ()
ENDFUNCTION ()

FUNCTION (ADD_FP_TARGETS SRCS FP_TARGETS)
  IF (CMAKE_C_COMPILER_ID STREQUAL Clang)
    STRING (REPLACE " " ";" SRCS "${SRCS}")
    FP_TARGET ("${SRCS}")
    X_TO_Y (".c" ".fp" "${SRCS}" FPTS)
    SET (${FP_TARGETS} "${FPTS}" PARENT_SCOPE)
  ENDIF ()
ENDFUNCTION ()
