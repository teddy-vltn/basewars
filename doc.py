import os

# Define the path to the directory containing the Lua files
lua_files_directory = "gamemode/"  # Adjust the path as necessary

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
    
    # Patterns to look for lines that start with "function BaseWars."
    pattern1 = "function BaseWars."
    pattern2 = "function Player:"
    
    # List to hold all function names
    function_names = []
    
    for line in lines:
        # Check if line starts with the pattern
        if line.strip().startswith(pattern1) or line.strip().startswith(pattern2):
            function_names.append(line.strip())
    
    return function_names

# Find all Lua files
lua_files = find_lua_files(lua_files_directory)

# Create a dictionary to hold functions for each category
categories = {
    'ServerSide': [],
    'SharedSide': [],
    'ClientSide': []
}

# Extract function names from all Lua files and categorize them
for lua_file in lua_files:
    function_names = extract_function_names(lua_file)
    base_file_name = os.path.basename(lua_file)
    if base_file_name.startswith('sv_'):
        categories['ServerSide'].extend(function_names)
    elif base_file_name.startswith('sh_'):
        categories['SharedSide'].extend(function_names)
    elif base_file_name.startswith('cl_'):
        categories['ClientSide'].extend(function_names)

# Path to the README file
readme_file_path = "README.md" 

# Open the README file and read the content
with open(readme_file_path, 'r') as file:
    lines = file.readlines()

# Find the index of the Documentation section
doc_start_index = next(i for i, line in enumerate(lines) if "## Documentation" in line) + 1
# Find the index of the Contributing section
contrib_index = next(i for i, line in enumerate(lines) if "## Contributing" in line)

# Remove the old documentation
lines = lines[:doc_start_index] + lines[contrib_index:]

# Function to insert categorized functions into README
def insert_functions(category_name, functions, insert_index):
    lines.insert(insert_index, f"### {category_name}\n\n")
    for name in reversed(functions):  # Reverse to keep the order when inserting
        lines.insert(insert_index + 1, f"```\n{name}\n```\n")

# Insert the new documentation for each category
insert_functions('Server Side Functions', categories['ServerSide'], doc_start_index)
insert_functions('Shared Side Functions', categories['SharedSide'], doc_start_index)
insert_functions('Client Side Functions', categories['ClientSide'], doc_start_index)

# Write the updated content back to the readme file
with open(readme_file_path, 'w') as file:
    file.writelines(lines)
