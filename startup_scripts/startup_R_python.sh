#!/usr/bin/env bash

apt-get update && \
    apt-get install -y less && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
conda install -y -c conda-forge mamba
mamba install -y -c bioconda \
      samtools bcftools bedtools fcsparser \
      scipy click numba pysam seaborn scikit-learn \
      kb-python
mamba install -y -c conda-forge multicore-tsne
mamba install -y -c conda-forge -c bioconda cellrank-krylov
mamba install -y -c anaconda cytoolz
pip install scanpy fa2 PhenoGraph pyscenic ngs-tools dynamo-release #infercnvpy requires python>=3.8
pip install --no-deps harmonyTS palantir doubletdetection
pip install numba
R -e 'BiocManager::install(c("LoomExperiment", "SingleCellExperiment", ask = F))'
R -e 'devtools::install_github("cellgeni/sceasy")'
R -e 'install.packages("reticulate")'