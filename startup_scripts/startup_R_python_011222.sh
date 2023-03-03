#!/usr/bin/env bash

add-apt-repository ppa:ubuntu-toolchain-r/test \
    && apt-get update && apt-get install -yq --no-install-recommends \
    gcc-10 g++-10 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 500 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 500
conda install -y -c conda-forge mamba
mamba install -y -c bioconda \
      samtools bcftools bedtools fcsparser \
      scipy click numba pysam seaborn scikit-learn \
      kb-python
mamba install -y -c conda-forge multicore-tsne hdbscan
mamba install -y -c conda-forge -c bioconda cellrank-krylov
mamba install -y -c anaconda cytoolz
pip install scanpy fa2 PhenoGraph pyscenic ngs-tools
pip install flit flit_core
pip install --no-deps harmonyTS palantir doubletdetection
pip install numba colorcet numdifftools
git clone https://github.com/aristoteleo/dynamo-release.git && \
cd dynamo-release/
python setup.py bdist_wheel --universal
cd dist/ && pip install dynamo_release-1.0.0-py2.py3-none-any.whl
cd /home/jupyter/
git clone https://github.com/dpeerlab/SEACells.git
pip install SEACells/
pip install pyparsing==2.4.2
R -e 'BiocManager::install(c("LoomExperiment", "SingleCellExperiment", ask = F))'
R -e 'devtools::install_github("cellgeni/sceasy")'
R -e 'install.packages("reticulate")'