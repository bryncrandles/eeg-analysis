#!/bin/bash

#SBATCH --job-name=mieeg301
#SBATCH --output=mieeg301.out
#SBATCH --error=mieeg301.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=3
#SBATCH --time=0-12:00
#SBATCH --mem=8G
#SBATCH --account=def-wjmarsha
#SBATCH --mail-user=db17bh@brocku.ca
#SBATCH --mail-type=ALL

module load matlab

matlab -nodisplay < mieeg301.m
