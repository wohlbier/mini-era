# docker build --build-arg PROXY=$http_proxy --pull -t tensorflow_opencv .
# nvidia-docker run -v /raid/user-scratch/jgwohlbier/EPOCHS/data:/data -v $(pwd):/workspace -it tensorflow_opencv:latest /bin/bash
# python mio_dataset.py
# python mio_training.py
# python mio_inference.py

#FROM nvcr.io/nvidia/tensorflow:20.03-tf2-py3 # tf2 no worky
FROM nvcr.io/nvidia/tensorflow:20.03-tf1-py3

ARG PROXY
ENV http_proxy $PROXY
ENV https_proxy $PROXY

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y \
    cmake \
    libsm6 \
    libxext6 \
    libxrender-dev

RUN /usr/bin/python -m pip install --upgrade pip
RUN pip install opencv-python
RUN pip install keras
