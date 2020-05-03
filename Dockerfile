# docker build --rm --build-arg PROXY=$http_proxy --pull -t miniera .
# on seville
# nvidia-docker run -v /raid/user-scratch/jgwohlbier/EPOCHS/data:/data -v $(pwd):/workspace -it miniera:latest /bin/bash
# on lambda
# docker run --gpus all -v /raid/user-scratch/jgwohlbier/EPOCHS/data:/data -v $(pwd):/workspace -it miniera:latest /bin/bash
# cd cv/CNN_MIO_KERAS
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
    emacs \
    libsm6 \
    libxext6 \
    libxrender-dev \
    python3-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install libopencv-dev -y

RUN python -m pip install --upgrade pip
RUN pip install opencv-python
RUN pip install keras
