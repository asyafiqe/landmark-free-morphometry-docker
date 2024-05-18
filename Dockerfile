# Use Ubuntu 18.04 as the base image
FROM ubuntu:18.04

# Set the working directory
WORKDIR /app

ENV TZ=Asia/Tokyo \
    DEBIAN_FRONTEND=noninteractive
    
# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 && \
    rm -rf /var/lib/apt/lists/*

# install R
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt-get update && \
    apt-get install -y r-base r-base-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    bash miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh

# Add Conda to the PATH
ENV PATH /opt/conda/bin:$PATH

# Install FSL
RUN wget https://git.fmrib.ox.ac.uk/fsl/installer/-/raw/master/fslinstaller.py?inline=false -O fslinstaller.py && \
    python fslinstaller.py -V 5.0.11 -d /usr/local/fsl -p

# Make FSL happy
ENV FSLDIR=/usr/local/fsl
ENV PATH=$FSLDIR/bin:$PATH
RUN /bin/bash -c 'source /usr/local/fsl/etc/fslconf/fsl.sh'
ENV FSLMULTIFILEQUIT=TRUE
ENV FSLOUTPUTTYPE=NIFTI_GZ

# Install landmark free
RUN git clone https://gitlab.com/ntoussaint/landmark-free-morphometry --depth 1 --branch=master
WORKDIR /app/landmark-free-morphometry
RUN conda env create -f data/environment_landmark-free_2023.yml && conda clean --all -y

# Activate the environment
ENV CONDA_DEFAULT_ENV landmark-free
RUN echo "source activate $CONDA_DEFAULT_ENV" >> ~/.bashrc
ENV PATH /opt/conda/envs/$CONDA_DEFAULT_ENV/bin:$PATH

# Install other package
RUN pip install --extra-index-url https://wheels.vtk.org matplotlib numpy SimpleITK vtk-osmesa jupyterlab && pip cache purge

# Expose the Jupyter Notebook port
EXPOSE 8888

# Set the default command to start the Jupyter Notebook
CMD ["jupyter", "lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.password=''"]







