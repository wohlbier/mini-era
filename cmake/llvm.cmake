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
FUNCTION (IR_TARGET SRCS)
   GET_INCS(cflags)
   FOREACH (f ${SRCS})
      STRING (REPLACE ".c" "" base ${f})
      ADD_CUSTOM_TARGET (${base}.ir
                         COMMAND clang -S -emit-llvm
                         ${cflags}
                         ${CMAKE_CURRENT_SOURCE_DIR}/${f}
                         -o ${CMAKE_CURRENT_BINARY_DIR}/${base}.ir)
   ENDFOREACH ()
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

FUNCTION (X_TO_Y dotX dotY Xs Ys)
   SET (l "")
   FOREACH (f ${Xs})
      STRING (REPLACE ${dotX} ${dotY} t ${f})
      SET (l "${l} ${t}")
   ENDFOREACH ()
   SET (${Ys} "${l}" PARENT_SCOPE)
ENDFUNCTION ()

FUNCTION (ADD_IR_TARGETS SRCS IR_TARGETS)
   IF (CMAKE_C_COMPILER_ID STREQUAL Clang)
      STRING (REPLACE " " ";" SRCS "${SRCS}")
      IR_TARGET ("${SRCS}")
      X_TO_Y (".c" ".ir" "${SRCS}" IRTS)
      SET (${IR_TARGETS} "${IRTS}" PARENT_SCOPE)
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
