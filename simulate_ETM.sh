#!/bin/bash
#SBATCH -t 00:15:00                 # Set the maximum time for the job HH:MM:SS
#SBATCH --mem=16G                   # Memory required for the job
#SBATCH --cpus-per-task=12          # Number of CPU cores per task
#SBATCH --job-name=simulate_ETM     # Job name
#SBATCH --output=simulate_ETM.log   # Output log file
#SBATCH --error=simulate_ETM.err    # Error log file

# Load the necessary modules
# module load matlab

# Define paths
OPTICKLE_DIR="C:\Users\jandr\Documents\Schoolwork\Fall 2024\Schoolwork\Homeworks\CMSC657\Optickle-Experiments\Optickle"

# Navigate to the Optickle directory
cd "$OPTICKLE_DIR"

# Debugging: Ensure the Optickle directory exists
if [ ! -d "$OPTICKLE_DIR" ]; then
    echo "Error: Optickle directory not found at $OPTICKLE_DIR"
    exit 1
fi

# Run MATLAB in no-GUI mode and execute the test
#matlab -nodisplay -nosplash -nodesktop -r "restoredefaultpath; rehash toolboxcache; savepath; path(pathdef); addpath(genpath(pwd)); run('$EXPERIMENT_SCRIPT');; exit;"
matlab -nosplash -nodesktop -r "restoredefaultpath; rehash toolboxcache; savepath('$OPTICKLE_DIR/pathdef.m'); path(pathdef); addpath(genpath('$OPTICKLE_DIR')); simulateETMSingleSource;"

echo "Simulation complete. Check simulate_ETM.log and simulate_ETM.err for details."