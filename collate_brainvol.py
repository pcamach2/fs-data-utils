import os
import pandas as pd
import csv

# Directory containing the CSV files
directory = "/path/to/gathered/csvs"

# Output file name
output_file = "brainvol_combined.csv"

# Initialize the combined data list
combined_data = []

# Iterate over all files in the directory
for filename in os.listdir(directory):
    if filename.endswith(".csv"):
        # Extract the participant ID from the file name
        participant_id = os.path.splitext(filename)[0]
        participant_id = participant_id.split("_")[0]
              
        # Read the CSV file
        file_path = os.path.join(directory, filename)
        data = pd.read_csv(file_path)

        # Add the participant ID to the data
        data["ParticipantID"] = participant_id

        # Append the data to the combined data list
        combined_data.append(data)

# Combine the data into a single DataFrame
combined_data = pd.concat(combined_data, ignore_index=True)

# Save the combined data to a new CSV file
output_path = os.path.join(directory, output_file)
combined_data.to_csv(output_path, index=False)
