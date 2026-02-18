import os
import re

dirs = ['lib', 'test', 'example']
patterns = [
    (r"import\s+['\"].*src/model/ds_request_model\.dart['\"];", "import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';"),
    (r"import\s+['\"].*src/model/ds_response_model\.dart['\"];", "import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';")
]

print("Starting replacement of model imports...")

for d in dirs:
    if not os.path.exists(d):
        continue
        
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        lines = f.readlines()
                    
                    new_lines = []
                    modified = False
                    
                    for line in lines:
                        replaced_line = line
                        for pat, repl in patterns:
                            if re.search(pat, line):
                                replaced_line = repl + '\n'
                                modified = True
                        new_lines.append(replaced_line)
                    
                    if modified:
                        # Remove duplicates if any (simple check)
                        unique_lines = []
                        seen_imports = set()
                        for line in new_lines:
                            if line.strip().startswith("import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';"):
                                if line in seen_imports:
                                    continue
                                seen_imports.add(line)
                            unique_lines.append(line)
                            
                        with open(path, 'w', encoding='utf-8') as f:
                            f.writelines(unique_lines)
                        print(f"Updated {path}")
                except Exception as e:
                    print(f"Failed to process {path}: {e}")

print("Done.")
