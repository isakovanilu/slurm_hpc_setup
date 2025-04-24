#!/bin/bash
#SBATCH --job-name=hello-test
#SBATCH --output=/tmp/hello-%j.out
#SBATCH --error=/tmp/hello-%j.err

echo "Hello from SLURM node!"
hostname
