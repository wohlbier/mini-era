# data image to get data files from
FROM miniera:data AS data
# accelseeker images
FROM accelseeker:latest AS as

# gpu
#FROM nvcr.io/nvidia/tensorflow:20.03-tf1-py3
# cpu
FROM tensorflow/tensorflow:1.15.2

# get data into new stage
COPY --from=data /data /data
RUN cd /data && \
    tar xJf MIO-TCD-Classification.tar.xz

# get AccelSeeker
COPY --from=as /workspace/AccelSeeker /workspace/AccelSeeker

ENV AS_PATH=/workspace/AccelSeeker
ENV PATH=${AS_PATH}/scripts:${AS_PATH}/accel_selection_algo_src:${PATH}

ARG PROXY
ENV http_proxy $PROXY
ENV https_proxy $PROXY

RUN apt-get update && \
    apt-get install -y \
    bc \
    cmake \
    emacs \
    less \
    libsm6 \
    libxext6 \
    libxrender-dev \
    python3-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install libopencv-dev -y

RUN python -m pip install --upgrade pip
RUN pip install opencv-python
RUN pip install keras

COPY . /workspace/mini-era

ENV LLVM_BIN_DIR=/workspace/AccelSeeker/llvm-8.0.0/build/bin
ENV PATH=${LLVM_BIN_DIR}:${PATH}
ENV LLVM_LIB_DIR=/workspace/AccelSeeker/llvm-8.0.0/build/lib

ENV PYTHONPATH=/workspace/mini-era/cv/CNN_MIO_KERAS
# create numpy data files
RUN cd /workspace/mini-era/cv/CNN_MIO_KERAS && \
    python mio_dataset.py

# build minieras
RUN cd /workspace/mini-era/build_gcc && \
    ../arch/gcc.sh && \
    make VERBOSE=1
RUN cd /workspace/mini-era/build_clang && \
    ../arch/clang.sh && \
    make VERBOSE=1

# when run with -v /path/to/arm:/arm
# also need --cap-add=SYS_PTRACE in docker run
ENV ALLINEA_LICENSE_DIR=/arm/forge/licenses
ENV PATH="/arm/forge/20.0.3/bin:${PATH}"
