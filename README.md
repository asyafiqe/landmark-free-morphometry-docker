# Landmark-free Morphometry Docker

This is a docker container for [Landmark-free Morphometry](https://gitlab.com/ntoussaint/landmark-free-morphometry) code from [A landmark-free morphometrics pipeline for high-resolution phenotyping: application to a mouse model of Down syndrome](https://doi.org/10.1242/dev.188631) paper.

Included in the container:
- Ubuntu 18.04
- Miniconda
- FSL 5.0.11
- SimpleITK
- vtk
- jupyterlab
- all packages in this [yaml](https://gitlab.com/ntoussaint/landmark-free-morphometry/-/raw/master/data/environment_landmark-free_2023.yml)

## Getting started
Install [Docker](https://docs.docker.com/engine/install/).
Pull and run the pre-built image. This will launch a jupyter lab instance.
```sh
docker run -p 8888:8888 asyafiqe/landmark-free-morphometry
```
Verify the deployment by navigating to your server address in
your preferred browser. 
```sh
127.0.0.1:8888
```
to attach a folder in the container, run:
```sh
docker run -v /path/to/my-data:/app/landmark-free-morphometry -p 8888:8888 asyafiqe/landmark-free-morphometry
```
or build yourself
```sh
git clone
cd
docker build -t <youruser>/landmark-free-morphometry .
```
