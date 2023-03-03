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
mamba install -y -c conda-forge multicore-tsne hdbscan
mamba install -y -c conda-forge -c bioconda cellrank-krylov
mamba install -y -c anaconda cytoolz
pip install scanpy fa2 PhenoGraph pyscenic ngs-tools #infercnvpy requires python>=3.8
pip install flit flit_core
pip install --no-deps harmonyTS palantir doubletdetection
pip install numba colorcet numdifftools
git clone https://github.com/dpeerlab/SEACells.git
pip install SEACells/
pip install pyparsing==2.4.2
R -e 'BiocManager::install(c("LoomExperiment", "SingleCellExperiment", ask = F))'
R -e 'devtools::install_github("cellgeni/sceasy")'
R -e 'install.packages("reticulate")'