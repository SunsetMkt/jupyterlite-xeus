#!/bin/bash
# https://github.com/jupyterlite/terminal/blob/main/deploy/deploy.sh
# https://jupyterlite.readthedocs.io/en/stable/howto/deployment/vercel-netlify.html#vercel
set -e

# Install wget
# yum is not available on netlify, but it´s not a problem because wget is already installed, this validation is just to avoid errors on build step.
if command -v yum &> /dev/null; then
    yum install wget -y
fi

# Download and extract Micromamba
wget -qO- https://micro.mamba.pm/api/micromamba/linux-64/2.0.5 | tar -xvj bin/micromamba

# Set up environment variables
export MAMBA_ROOT_PREFIX="$PWD/micromamba"
export PATH="$PWD/bin:$PATH"

# Initialize Micromamba shell
./bin/micromamba shell init -s bash --no-modify-profile -p $MAMBA_ROOT_PREFIX

# Source Micromamba environment directly
eval "$(./bin/micromamba shell hook -s bash)"

# Activate the Micromamba environment
micromamba create -n jupyterenv python=3.12 -c conda-forge -f build-environment.yml -y
micromamba activate jupyterenv

# build the JupyterLite site
cp README.md content
jupyter lite --version
jupyter lite build --contents content --output-dir dist --debug