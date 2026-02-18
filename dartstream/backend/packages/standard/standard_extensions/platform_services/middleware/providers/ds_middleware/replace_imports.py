import os

dirs = ['lib', 'test', 'example']
target = 'package:ds_custom_middleware'
replacement = 'package:ds_middleware'

print(f"Starting replacement of {target} with {replacement}...")

for d in dirs:
    if not os.path.exists(d):
        print(f"Directory {d} does not exist, skipping.")
        continue
        
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    if target in content:
                        new_content = content.replace(target, replacement)
                        with open(path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"Updated {path}")
                except Exception as e:
                    print(f"Failed to process {path}: {e}")

print("Done.")
