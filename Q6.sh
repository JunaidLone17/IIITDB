#!/bin/bash

# Function to convert the given date into a timestamp format for comparison
convert_to_timestamp() {
    date -d "$1" +"%Y-%m-%d %H:%M:%S" 2>/dev/null
}

# Check if the "Logs" directory exists
if [ ! -d "Logs" ]; then
    echo "The 'Logs' directory does not exist."
    exit 1
fi

# Read the given date from the command-line argument
if [ $# -eq 0 ]; then
    echo "Usage: $0 <YYYY-MM-DD>"
    exit 1
fi

given_date=$1
given_timestamp=$(convert_to_timestamp "$given_date")

if [ -z "$given_timestamp" ]; then
    echo "Invalid date format. Please use 'YYYY-MM-DD'."
    exit 1
fi

# Initialize an array to store the filtered log entries
filtered_logs=()

# Loop through each log file in the "Logs" directory
for log_file in Logs/log_*.txt; do
    # Extract the timestamp and message from each log entry
    while IFS= read -r line; do
        if [[ $line == "Timestamp: "* ]]; then
            timestamp=${line#Timestamp: }
            # Extract the year, month, and day from the timestamp
            year=$(echo "$timestamp" | cut -d'-' -f1)
            month=$(echo "$timestamp" | cut -d'-' -f2)
            day=$(echo "$timestamp" | cut -d'-' -f3 | cut -d' ' -f1)
            
            # Check if the day is a valid number, if not, set it to 01
            if ! [[ "$day" =~ ^[0-9]+$ ]]; then
                day="01"
            fi
            
            # Pad the day with leading zeroes to ensure proper date format
            day=$(printf "%02d" "$day")
            
            # Reassemble the timestamp
            timestamp="$year-$month-$day $(echo "$timestamp" | cut -d' ' -f2-)"
            
            # Read the message until an empty line is encountered
            IFS= read -r message_line
            message=""
            while [ "$message_line" != "" ]; do
                message+="$message_line"$'\n'
                IFS= read -r message_line
            done
            
            # Check if the timestamp is older than the given date
            if [ "$(convert_to_timestamp "$timestamp")" \< "$(convert_to_timestamp "$given_date")" ]; then
                # Add the log entry to the filtered_logs array
                filtered_logs+=("Timestamp: $timestamp\n$message")
            fi
        fi
    done < "$log_file"
done

# Sort the filtered log entries in descending order based on timestamps
sorted_logs=$(printf '%s' "${filtered_logs[@]}" | sort -r -t ':' -k 2)

# Write the sorted log entries to the "filtered_logs.txt" file
echo -e "$sorted_logs" > "filtered_logs.txt"

echo "Filtered log entries have been written to filtered_logs.txt."
