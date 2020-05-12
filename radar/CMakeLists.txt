SET (LIB_SRCS
     calculate_dist_from_fmcw.c)

ADD_LIBRARY (radar ${LIB_SRCS})
TARGET_LINK_LIBRARIES (radar fft-1d)

ADD_EXECUTABLE (main main.c)
TARGET_LINK_LIBRARIES (main radar)
