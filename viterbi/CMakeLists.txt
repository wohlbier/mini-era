SET (LIB_SRCS
     descrambler_function.c
     viterbi_decoder_generic.c
     viterbi_standalone.c)

ADD_LIBRARY(viterbi ${LIB_SRCS})

SET (LIB_FV_SRCS
     descrambler_function.c
     viterbi_flat.c
     viterbi_standalone.c)

ADD_LIBRARY(fv_viterbi ${LIB_FV_SRCS})

ADD_EXECUTABLE (vtest vtest.c)
TARGET_LINK_LIBRARIES (vtest viterbi)

ADD_EXECUTABLE (viterbi_test viterbi_test.c)
TARGET_LINK_LIBRARIES (viterbi_test viterbi)

ADD_IR_TARGETS ("${LIB_SRCS}" IRTS IRFS)
SET (IR_TARGETS "${IRTS};${IR_TARGETS}" PARENT_SCOPE)
SET (IR_FILES "${IRFS};${IR_FILES}" PARENT_SCOPE)

ADD_FP_TARGETS ("${LIB_SRCS}" FPTS)
SET (FP_TARGETS "${FPTS};${FP_TARGETS}" PARENT_SCOPE)
