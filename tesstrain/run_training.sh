# #!/bin/bash

# export TESSDATA_PREFIX=../tesseract/tessdata

# # Function to run the training process
# run_training() {
#     # Clear previous error log
#     > error.log

#     # Run training command and redirect stderr to log
#     make training MODEL_NAME=earthMomma START_MODEL=eng TESSDATA=../tesseract/tessdata MAX_ITERATIONS=10000 2> error.log

#     # Check for specific error pattern and handle it
#     if grep -q "Failed to read boxes from" error.log; then
#         # Extract the filename from the error message
#         problem_file=$(grep "Failed to read boxes from" error.log | sed -n 's/.*Failed to read boxes from \(.*\)\.tif.*/\1.tif/p')

#         echo "Debug: Error Log Content:"
#         cat error.log
        
#         echo "Problematic file detected: $problem_file"
        
#         if [[ -n "$problem_file" ]]; then
#             echo "Removing problematic files..."
#             # Remove all related files
#             rm "${problem_file}" "${problem_file%.*}.box" "${problem_file%.*}.gt.txt"

#             echo "Files removed. Restarting the training process..."
#             # Call the function recursively to restart the training process
#             run_training
#         else
#             echo "No file name extracted. Please check the error log manually."
#         fi
#     else
#         echo "Training completed without errors or no more errors detected."
#     fi
# }

# # Initial call to the training function
# run_training



#!/bin/bash

export TESSDATA_PREFIX=../tesseract/tessdata

# Function to run the training process
run_training() {
    # Clear previous error log
    > error.log

    # Run training command and redirect stderr to log
    make training MODEL_NAME=earthMomma START_MODEL=eng TESSDATA=../tesseract/tessdata MAX_ITERATIONS=10000 2> error.log

    # Check for specific error pattern and handle it
    if grep -q "Failed to read boxes from" error.log; then
        # Extract the filename from the error message
        problem_file=$(grep "Failed to read boxes from" error.log | sed -n 's/.*Failed to read boxes from \(.*\)\.tif.*/\1.tif/p')

        echo "Debug: Error Log Content:"
        cat error.log
        
        echo "Problematic file detected: $problem_file"
        
        if [[ -n "$problem_file" ]]; then
            echo "Removing problematic files..."
            # Ensure paths are correctly constructed
            base_name=$(basename "$problem_file" .tif) # Extracts the filename without extension
            directory=$(dirname "$problem_file")       # Extracts the directory path

            # Remove all related files
            rm "${directory}/${base_name}.tif" "${directory}/${base_name}.box" "${directory}/${base_name}.gt.txt"

            echo "Files removed. Restarting the training process..."
            # Call the function recursively to restart the training process
            run_training
        else
            echo "No file name extracted. Please check the error log manually."
        fi
    else
        echo "Training completed without errors or no more errors detected."
    fi
}

# Initial call to the training function
run_training
