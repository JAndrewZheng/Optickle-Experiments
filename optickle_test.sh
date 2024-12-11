#!/bin/bash
#SBATCH -t 00:45:00                 # Set the maximum time for the job HH:MM:SS
#SBATCH --mem=16G                   # Memory required for the job
#SBATCH --cpus-per-task=12          # Number of CPU cores per task
#SBATCH --job-name=optickle_demo    # Job name
#SBATCH --output=optickle_demo.log  # Output log file
#SBATCH --error=optickle_demo.err   # Error log file

# Load the MATLAB module (adjust the module name if needed)
# module load matlab

# Navigate to the Optickle directory
cd "C:\Users\jandr\Documents\Schoolwork\Fall 2024\Schoolwork\Homeworks\CMSC657\Optickle-Experiments\Optickle"

# Run MATLAB in no-GUI mode and execute the test
matlab -nodisplay -nosplash -nodesktop -r "path(pathdef); addpath(genpath(pwd)); demoDetuneFP; exit;"
