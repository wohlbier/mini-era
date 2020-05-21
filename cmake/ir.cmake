# adds target for IR.
FUNCTION (IR_TARGET SRCS)
   GET_PROPERTY (dirs
                 DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                 PROPERTY INCLUDE_DIRECTORIES)
   FOREACH (d ${dirs})
      SET (inc_dirs "-I${d} ${inc_dirs}")
   ENDFOREACH ()
   SET (cflags "${inc_dirs} ${CMAKE_C_FLAGS}")
   STRING (REPLACE " " ";" cflags ${cflags})
   FOREACH (f ${SRCS})
      STRING (REPLACE ".c" "" base ${f})
      ADD_CUSTOM_TARGET (${base}.ir
                         COMMAND clang -S -emit-llvm
                         ${cflags}
                         ${CMAKE_CURRENT_SOURCE_DIR}/${f}
                         -o ${CMAKE_CURRENT_BINARY_DIR}/${base}.ir)
   ENDFOREACH ()
ENDFUNCTION ()

FUNCTION (SRC_TO_IR SRCS IRS)
   SET (l "")
   FOREACH (f ${SRCS})
      STRING (REPLACE ".c" ".ir" t ${f})
      SET (l "${l} ${t}")
   ENDFOREACH ()
   SET (${IRS} "${l}" PARENT_SCOPE)
ENDFUNCTION ()

FUNCTION (ADD_IR_TARGETS SRCS IR_TARGETS)
   IF (CMAKE_C_COMPILER_ID STREQUAL Clang)
      STRING (REPLACE " " ";" SRCS "${SRCS}")
      IR_TARGET ("${SRCS}")
      SRC_TO_IR ("${SRCS}" IRTS)
      SET (${IR_TARGETS} "${IRTS}" PARENT_SCOPE)
   ENDIF ()
ENDFUNCTION ()
