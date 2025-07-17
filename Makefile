# Build docker project
.PHONY : docker_build
docker_build:
	docker build -t egoplannerswarm .

# Run docker project
.PHONY : docker_run
docker_run:
	docker run -it --network host --env="DISPLAY" --env="QT_X11_NO_MITSHM=1"  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --entrypoint /bin/bash egoplannerswarm

# Run docker project with roscore
.PHONY : docker_roscore
docker_roscore:
	docker run -d --name egoplannerswarm --network host -e DISPLAY=$DISPLAY --env="QT_X11_NO_MITSHM=1"  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" egoplannerswarm roscore

# Run docker test gpu
.PHONY : docker_gpu_test
docker_gpu_test:
	docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi

# Run docker project with GPU support
.PHONY : docker_roscore_gpu
docker_roscore_gpu:
	docker run -d --network host --runtime=nvidia --gpus all -e DISPLAY=$DISPLAY --env="QT_X11_NO_MITSHM=1"  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" --name egoplannerswarm egoplannerswarm roscore

# Enter the docker container
.PHONY : docker_enter
docker_enter:
	docker exec -it egoplannerswarm /bin/bash