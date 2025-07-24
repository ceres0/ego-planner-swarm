# Import CUDA support
FROM nvidia/cuda:11.5.2-devel-ubuntu20.04 AS cuda_stage

# Use the official ROS Melodic base image
# FROM ubuntu:20.04
FROM ros:noetic-perception

# Set the working directory
WORKDIR /workspace

# RUN cp /etc/apt/sources.list /etc/apt/sources.list.backup

RUN sed -i 's/ports.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

# RUN apt-get update \ 
#     && apt-get install -y --quiet --no-install-recommends \
#     lsb-release curl sudo gnupg2

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt-get update \ 
    && apt-get install -y --quiet --no-install-recommends \
    ros-noetic-desktop-full

# Install additional dependencies if needed
# For example, you can uncomment the line below to install a package
# Install additional dependencies
RUN apt-get update \
    && apt-get -y --quiet --no-install-recommends install \
    gcc \
    git \
    libxml2-dev \
    libxslt-dev \
    python3 \
    python3-pip\ 
    python3-scipy \
    ros-noetic-tf\
    ros-noetic-interactive-markers\
    ros-noetic-image-geometry\
    ros-noetic-xacro

RUN pip3 install setuptools
RUN pip3 install pykalman catkin-tools
# Copy your ROS packages into the workspace
COPY . /workspace/src/

WORKDIR /workspace

# COPY the CUDA toolkit from the cuda_stage
COPY --from=cuda_stage /usr/local/cuda /usr/local/cuda

# Set environment variables
ENV ROS_DISTRO noetic
ENV ROS_VERSION 1

# Set up the environment for cuda
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# RUN catkin build
RUN . /opt/ros/noetic/setup.sh && catkin_make -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXPORT_COMPILE_COMMANDS=Yes


# Source the ROS setup file
RUN echo "source /workspace/devel/setup.bash" >> ~/.bashrc

# Expose ROS master port
EXPOSE 11311

# Set entry point to start ROS
CMD ["roscore"]
