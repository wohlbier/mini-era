SET (LIB_SRC
     descrambler_function.c
     viterbi_decoder_generic.c
     viterbi_standalone.c)

ADD_LIBRARY(viterbi ${LIB_SRC})

SET (LIB_FV_SRC
     descrambler_function.c
     viterbi_flat.c
     viterbi_standalone.c)

ADD_LIBRARY(fv_viterbi ${LIB_FV_SRC})

ADD_EXECUTABLE (vtest vtest.c)
TARGET_LINK_LIBRARIES (vtest viterbi)

ADD_EXECUTABLE (viterbi_test viterbi_test.c)
TARGET_LINK_LIBRARIES (viterbi_test viterbi)
