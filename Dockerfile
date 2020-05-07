# docker build --rm --build-arg PROXY=$http_proxy -t miniera .
# on seville
# nvidia-docker run -it miniera:latest /bin/bash
# on lambda
# docker run --gpus all -it miniera:latest /bin/bash

# data image to get data files from
FROM miniera:data AS data

# gpu
#FROM nvcr.io/nvidia/tensorflow:20.03-tf1-py3
# cpu
FROM tensorflow/tensorflow:1.15.2

# get data into new stage
COPY --from=data /data /data
RUN cd /data && \
    tar xJf MIO-TCD-Classification.tar.xz

ARG PROXY
ENV http_proxy $PROXY
ENV https_proxy $PROXY

RUN apt-get update && \
    apt-get install -y \
    cmake \
    emacs \
    libsm6 \
    libxext6 \
    libxrender-dev \
    python3-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install libopencv-dev -y

RUN python -m pip install --upgrade pip
RUN pip install opencv-python
RUN pip install keras

COPY . /workspace/mini-era

ENV PYTHONPATH=/workspace/mini-era/cv/CNN_MIO_KERAS
RUN cd /workspace/mini-era && \
    make allclean && \
    make all

# create numpy data files
RUN cd /workspace/mini-era/cv/CNN_MIO_KERAS && \
    python mio_dataset.py

# when run with -v /path/to/arm:/arm
ENV ALLINEA_LICENSE_DIR=/arm/forge/licenses
ENV PATH="/arm/forge/20.0.3/bin:${PATH}"
