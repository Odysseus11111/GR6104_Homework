#!/bin/bash
#SBATCH --account=edu
#SBATCH --job-name=hw4_jackknife
#SBATCH --nodes=1
#SBATCH --cpus-per-task=50
#SBATCH --mem-per-cpu=3G
#SBATCH --time=02:00:00
#SBATCH --output=slurm-%j.out

module load julia

cd ../src

julia --threads=50 part2-jackknife.jl


