
# Prompt the user to enter the name of a directory
read -p "Enter the name of the directory: " directory_name

# Check if the directory exists
if [ ! -d "$directory_name" ]; then
    echo "Directory '$directory_name' does not exist."
fi

# List all the files in the given directory
echo "Files in the directory '$directory_name':"
files=$(ls "$directory_name")
echo "$files"

# Sort the files alphabetically
sorted_files=$(echo "$files" | sort)

# Create a new directory named "sorted" inside the given directory
new_directory="$directory_name/sorted"
mkdir -p "$new_directory"

# Move each file from the original directory to the "sorted" directory
moved_files=0
for file in $sorted_files; do
    mv "$directory_name/$file" "$new_directory/"
    ((moved_files++))
done

# Display a success message with the total number of files moved
echo "Successfully moved $moved_files files to '$new_directory'."

