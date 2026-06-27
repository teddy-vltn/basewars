import os
import re

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

def doc_to_markdown(doc):
    if not doc:
        return 'No documentation available for now.'

    # Remove the initial and final comment block delimiters
    doc = re.sub(r'/\*|\*/', '', doc).strip()

    # Initialize a list to hold the processed lines
    processed_lines = []
    # Initialize a variable to track whether we are inside an example block
    inside_example_block = False

    # Process each line of the documentation block
    for line in doc.split('\n'):
        # Remove leading asterisks and whitespace
        line = line.lstrip('* \t')

        if '@description' in line:
            # Extract description
            description = line.replace('@description', '').strip()
            processed_lines.append(description + '\n')
        elif '@param' in line:
            # Extract parameters
            param = re.sub(r'@param\s+\{([\w|\s]+)\}\s+(\w+)\s+-\s+', r'- **Parameter** `\2` (\1): ', line)
            processed_lines.append(param)
        elif '@return' in line:
            # Extract return values
            return_statement = re.sub(r'@return\s+\{([\w, ]+)\}\s+', r'- **Returns** `\1`: ', line)
            processed_lines.append(return_statement)
        elif '@example' in line:
            if inside_example_block:
                # If we're already in an example block, this @example ends it
                processed_lines.append('```')
                inside_example_block = False
            else:
                # If we're not in an example block, this @example starts it
                processed_lines.append('**Example:**\n```lua')
                inside_example_block = True
        elif inside_example_block:
            # We're inside an example block, add the line as code
            processed_lines.append(line)
        else:
            # Other lines go unchanged
            processed_lines.append(line)

    # Ensure the example code block is closed if it was opened
    if inside_example_block:
        processed_lines.append('```')

    # Join the processed lines back into a single string
    return '\n'.join(processed_lines).strip()

# Function to extract function names and their optional documentation
def extract_functions_and_docs(file_path):
    with open(file_path, 'r') as file:
        content = file.read()

    # Regular expression pattern to match Lua function definitions with specific prefixes and their optional documentation comments
    pattern = re.compile(r"(?:(/\*[\s\S]*?\*/)\s*)?function\s+(Player:|BaseWars\.|Faction:)(\w+)([^\)]*\))", re.MULTILINE)
    
    # List to hold tuples of (documentation, function signature, file path and line number)
    functions_with_docs = []

    # Find all matches
    for match in pattern.finditer(content):
        doc_block, prefix, func_name, params = match.groups()
        # Calculate the line number based on the start of the match
        line_number = content.count('\n', 0, match.start()) + 1
        doc_markdown = doc_to_markdown(doc_block)
        full_func_signature = f"function {prefix}{func_name}{params}"
        location_note = f"***Located at {os.path.relpath(file_path, start=lua_files_directory)}: Line {line_number}***"
        functions_with_docs.append((doc_markdown, full_func_signature, location_note))

    return functions_with_docs

# Find all Lua files
lua_files = find_lua_files(lua_files_directory)

# Create a dictionary to hold functions and their documentation for each category
categories = {
    'ServerSide': [],
    'SharedSide': [],
    'ClientSide': []
}

# Extract function names and their documentation from all Lua files and categorize them
for lua_file in lua_files:
    functions_with_docs = extract_functions_and_docs(lua_file)
    base_file_name = os.path.basename(lua_file)
    if base_file_name.startswith('sv_') or base_file_name == 'init.lua':
        categories['ServerSide'].extend(functions_with_docs)
    elif base_file_name.startswith('sh_') or base_file_name == 'shared.lua':
        categories['SharedSide'].extend(functions_with_docs)
    elif base_file_name.startswith('cl_') or base_file_name == 'cl_init.lua':
        categories['ClientSide'].extend(functions_with_docs)

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
lines = lines[:doc_start_index] + ['\n'] + lines[contrib_index:]

# Function to insert categorized functions into README
def insert_functions(category_name, functions_with_docs, insert_index):
    lines.insert(insert_index, f"### {category_name} Functions\n\n")
    for doc, func, location_note in reversed(functions_with_docs):
        entry = f"> {location_note}\n```lua\n{func}\n```\n\n\n{doc}\n\n---\n\n"
        lines.insert(insert_index + 1, entry)

# Insert the new documentation for each category
insert_functions('Server-Side', categories['ServerSide'], doc_start_index)
insert_functions('Shared-Side', categories['SharedSide'], doc_start_index)
insert_functions('Client-Side', categories['ClientSide'], doc_start_index)

# Write the updated content back to the README file
with open(readme_file_path, 'w') as file:
    file.writelines(lines)
