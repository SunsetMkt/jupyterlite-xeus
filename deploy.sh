#!/bin/bash
# https://jupyterlite.readthedocs.io/en/stable/howto/deployment/vercel-netlify.html#vercel
set -e

# Install wget
# yum is not available on netlify, but it´s not a problem because wget is already installed, this validation is just to avoid errors on build step.
if command -v yum &> /dev/null; then
    yum install wget -y
fi

# Download and extract Micromamba
wget -qO- https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

# Set up environment variables
export MAMBA_ROOT_PREFIX="$PWD/micromamba"
export PATH="$PWD/bin:$PATH"

# Create the environment
micromamba create -n jupyterenv python=3.12 -f build-environment.yml -y

# Build JupyterLite
cp README.md content/PREBUILT_README.md
micromamba run -n jupyterenv jupyter lite --version
micromamba run -n jupyterenv jupyter lite build --contents content --output-dir dist --debug