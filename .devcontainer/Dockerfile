# Use the NVIDIA CUDA base image with Ubuntu 20.04
FROM nvidia/cuda:11.3.1-cudnn8-runtime-ubuntu20.04


# Set environment variables for non-interactive installations and locale
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

# Set up locale
RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US.UTF-8 \
    && update-locale LANG=en_US.UTF-8 \
    && apt-get clean

# Install necessary packages
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    lsb-release \
    gnupg2 \
    curl \
    libgl1-mesa-glx \
    libxext6 \
    libx11-6 \
    libglu1-mesa \
    mesa-utils \
    software-properties-common \
    && apt-get clean

# Install CUDA Toolkit for nvcc:
# Change CUDA version for a compatible version of your NVIDIA Driver
# Run nvidia-smi to see your current NVIDIA Driver version.
RUN apt-get update && \
    apt-get install -y cuda-toolkit-12-6 && \
    rm -rf /var/lib/apt/lists/*
ENV PATH=/usr/local/cuda-12.6/bin:${PATH}


# Download the Miniconda installer script, and install
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
RUN bash /tmp/miniconda.sh -b -p /opt/conda
ENV PATH=/opt/conda/bin:$PATH
RUN rm /tmp/miniconda.sh

# Initialize Conda in every new shell
# RUN /opt/conda/bin/conda init bash


# Edit below parts to install another ros distro.
#===========================================================================================================

# Add the ROS Noetic repository and install ROS Noetic desktop full along with MoveIt, RViz, and Gazebo
RUN echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list \
    && curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.key | apt-key add - \
    && apt-get update && apt-get install -y \
        ros-noetic-desktop-full \
        ros-noetic-moveit \
        python3-rosdep \
        python3-rosinstall \
        python3-rosinstall-generator \
        python3-wstool \
        build-essential \
        ros-noetic-rviz \
        ros-noetic-gazebo-ros \
        ros-noetic-gazebo-ros-pkgs \
        ros-noetic-gazebo-plugins \
    && apt-get clean

# Install catkin tools
RUN apt-get update && apt-get install -y \
    python3-catkin-tools \
    && apt-get clean

# Install and initialize rosdep
RUN apt-get update && apt-get install -y python3-rosdep \
    && rosdep init \
    && rosdep update \
    && apt-get clean

# Install dependencies for Miniconda
RUN apt-get update && apt-get install -y wget && apt-get clean

# Source the ROS environment and setup bashrc
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc

# Create the catkin workspace directories
RUN mkdir -p /ros_ws/src

#============================================================================================================

# Set the working directory
WORKDIR /ros_ws

# Mark /root as a volume
VOLUME /ros_ws

# Set the entry point to bash
CMD ["/bin/bash"]
