FROM us.gcr.io/broad-dsp-gcr-public/terra-jupyter-bioconductor:2.1.8

USER root
# This makes it so pip runs as root, not the user.
ENV PIP_USER=false

RUN add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update && apt-get install -yq --no-install-recommends \
    gcc-10 g++-10 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 500 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 500

RUN conda update -n base conda && \
    conda install -y -c conda-forge mamba && \
    conda create -y -n python38 python=3.8 && \
    chown -R jupyter:jupyter /opt/conda/envs/python38 && \
    . /opt/conda/etc/profile.d/conda.sh && \
    conda activate python38 && \    
    mamba install -y -c bioconda \
    samtools bcftools bedtools fcsparser \
    scipy click numba pysam seaborn scikit-learn \
    kb-python && \
    mamba install -y -c conda-forge multicore-tsne hdbscan mscorefonts && \
    mamba install -y -c conda-forge -c bioconda cellrank-krylov && \
    mamba install -y -c anaconda cytoolz && \
    conda clean -afy

RUN . /opt/conda/etc/profile.d/conda.sh && conda activate python38 && \
    pip install scanpy fa2 PhenoGraph pyscenic ngs-tools infercnvpy SEACells episcanpy && \
    pip install flit flit_core && \
    pip install --no-deps harmonyTS palantir doubletdetection && \
    pip install numba colorcet numdifftools && \
    pip install llvmlite --ignore-installed

RUN R -e 'BiocManager::install(c("LoomExperiment", "SingleCellExperiment", "Seurat", "infercnv", ask = F))' && \
    R -e 'devtools::install_github("cellgeni/sceasy")' && \
    R -e 'install.packages("reticulate")'

RUN . /opt/conda/etc/profile.d/conda.sh && conda activate python38 && \
    git clone https://github.com/aristoteleo/dynamo-release.git && \
    pip install dynamo-release/ && \
    git clone https://github.com/aertslab/scenicplus && \
    pip install scenicplus/ --no-dependencies && \
    rm -rf dynamo-release/ && rm -rf SEACells/ && rm -rf scenicplus/

RUN . /opt/conda/etc/profile.d/conda.sh && conda activate python38 && \
    mamba install -y pytorch cpuonly -c pytorch && \
    mamba install -y scvi-tools gseapy scirpy -c bioconda -c conda-forge && \
    conda clean -afy && \
    pip install harmonypy cdlib cospar muon shannonca openpyxl IProgress altocumulus crcmod && \
    pip install pychromvar

RUN . /opt/conda/etc/profile.d/conda.sh && conda activate python38 && \
    pip install ipykernel && \
    python -m ipykernel install --name=python38

ENV NUMBA_CACHE_DIR=/home/jupyter/notebooks/cache/numba_cache
ENV MPLCONFIGDIR=/home/jupyter/notebooks/cache/matplotlib_cache

# make jupyter root user and set password to jupyter
RUN usermod -a -G sudo jupyter
RUN echo "jupyter:jupyter" | sudo chpasswd

ENV USER jupyter
USER $USER
# We want pip to install into the user's dir when the notebook is running.
ENV PIP_USER=true

ENTRYPOINT ["/opt/conda/bin/jupyter", "notebook"]