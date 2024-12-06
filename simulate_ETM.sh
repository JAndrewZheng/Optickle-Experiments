#!/bin/bash
#SBATCH -t 00:15:00                 # Set the maximum time for the job HH:MM:SS
#SBATCH --mem=16G                   # Memory required for the job
#SBATCH --cpus-per-task=12          # Number of CPU cores per task
#SBATCH --job-name=simulate_ETM     # Job name
#SBATCH --output=simulate_ETM.log   # Output log file
#SBATCH --error=simulate_ETM.err    # Error log file

# Load the necessary modules
module load matlab

# Define paths

### BRANDON PATHS
# OPTICKLE_DIR="/home/brandcol/scratch.regli-prj/Uni_Class_projects/CMSC657_QUANT/Optickle"
# EXPERIMENT_SCRIPT="/home/brandcol/scratch.regli-prj/Uni_Class_projects/CMSC657_QUANT/Optickle/Experiments/simulate_ETM.m"
# LOG_FILE="/home/brandcol/scratch.regli-prj/Uni_Class_projects/CMSC657_QUANT/Optickle/Experiments/simulation_output.log"

### ANDREW PATHS
OPTICKLE_DIR="/vulcanscratch/azheng15/fall2024/CMSC657/final_project/Optickle"
EXPERIMENT_SCRIPT="/vulcanscratch/azheng15/fall2024/CMSC657/final_project/Optickle/Optickle-Experiments/simulate_ETM.m"
LOG_FILE="/vulcanscratch/azheng15/fall2024/CMSC657/final_project/Optickle/Optickle-Experiments/simulate_ETM.log"

# Navigate to the Optickle directory
cd "$OPTICKLE_DIR"

# Debugging: Ensure the Optickle directory exists
if [ ! -d "$OPTICKLE_DIR" ]; then
    echo "Error: Optickle directory not found at $OPTICKLE_DIR"
    exit 1
fi

# Debugging: Check if the experiment script exists
if [ ! -f "$EXPERIMENT_SCRIPT" ]; then
    echo "Error: MATLAB script not found at $EXPERIMENT_SCRIPT"
    exit 1
fi

# # Run MATLAB script
# echo "Starting MATLAB simulation with proper quoting..."
# matlab -nodisplay -nosplash -nodesktop -r "try, \
#     path(pathdef); \
#     addpath(genpath('$OPTICKLE_DIR')); \
#     disp('MATLAB paths added successfully!'); \
#     if exist('optFP', 'class'), \
#         disp('Optickle loaded successfully!'); \
#     else, \
#         error('Optickle package not found. Ensure the Optickle directory is correctly added to the path.'); \
#     end; \
#     diary('$LOG_FILE'); \
#     diary on; \
#     disp('Running simulation script...'); \
#     run('$EXPERIMENT_SCRIPT'); \
#     disp('Simulation completed successfully!'); \
#     diary off; \
# catch ME, \
#     disp('An error occurred during the MATLAB execution:'); \
#     disp(ME.message); \
#     diary off; \
# end; \
# exit;"

# Run MATLAB in no-GUI mode and execute the test
matlab -nodisplay -nosplash -nodesktop -r "path(pathdef); addpath(genpath(pwd)); simulate_ETM; exit;"


# Debugging: Check if the log file was created
# if [ -f "$LOG_FILE" ]; then
#     echo "Simulation log created successfully at $LOG_FILE"
#     echo "Log content preview:"
#     tail -n 20 "$LOG_FILE"
# else
#     echo "Error: Simulation log file not created. Check simulate_ETM.err for details."
# fi

echo "Simulation complete. Check simulate_ETM.log and simulate_ETM.err for details."
