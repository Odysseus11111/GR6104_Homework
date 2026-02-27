#!/bin/bash
#SBATCH --account=edu
#SBATCH --job-name=hw4_jackknife
#SBATCH --nodes=1
#SBATCH --cpus-per-task=50
#SBATCH --mem-per-cpu=200M
#SBATCH --time=02:00:00
#SBATCH --output=slurm-%j.out

module load Julia

cd ../src

julia --threads=50 part2-jackknife.jl