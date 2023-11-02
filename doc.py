import os

# Define the path to the directory containing the Lua files
lua_files_directory = "gamemode/"  # Assuming the files are uploaded to the 'data' directory

# Function to recursively find all Lua files
def find_lua_files(directory):
    lua_files = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.lua'):
                lua_files.append(os.path.join(root, file))
    return lua_files

# Function to extract function names
def extract_function_names(file_path):
    with open(file_path, 'r') as file:
        lines = file.readlines()
    
    # Pattern to look for lines that start with "function BaseWars."
    pattern = "function BaseWars."
    
    # List to hold all function names
    function_names = []
    
    for line in lines:
        # Check if line starts with the pattern
        if line.strip().startswith(pattern):
            function_names.append(line.strip())
    
    return function_names

# Find all Lua files
lua_files = find_lua_files(lua_files_directory)

# Extract function names from all Lua files
all_function_names = []
for lua_file in lua_files:
    function_names = extract_function_names(lua_file)
    all_function_names.extend(function_names)

readme_file_path = "readme.md"
with open(readme_file_path, 'r') as file:
    lines = file.readlines()

# Find the index of the Documentation section
doc_start_index = next(i for i, line in enumerate(lines) if "## Documentation" in line) + 1
# Find the index of the Contributing section
contrib_index = next(i for i, line in enumerate(lines) if "## Contributing" in line)

# Remove the old documentation
lines = lines[:doc_start_index] + lines[contrib_index:]

# Insert the new documentation
for name in reversed(all_function_names):  # Reverse to keep the order when inserting
    lines.insert(doc_start_index, f"```\n{name}\n```\n")

# Write the updated content back to the readme file
with open(readme_file_path, 'w') as file:
    file.writelines(lines)

