import os
import re

dirs = ['lib', 'test']

# Fix relative imports in src/routing or anywhere else
# Pattern: import '../model/ds_request_model.dart'; -> import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';
# Pattern: import '../model/ds_response_model.dart'; -> import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';

import_patterns = [
    (r"import\s+['\"]\.{2}/model/ds_request_model\.dart['\"];", "import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';"),
    (r"import\s+['\"]\.{2}/model/ds_response_model\.dart['\"];", "import 'package:ds_middleware/app/models/ds_custom_middleware_model.dart';")
]

# Fix constructor calls
# Warning: This is a simple regex, might be fragile if constructor call spans multiple lines in complex ways.
# But looking at the files, they seem relatively simple.
# Example: DsCustomMiddleWareRequest('GET', Uri.parse(...), {}, {}) -> missing 5th arg.
# We want to add ', {}' before the closing parenthesis if it looks like it has 4 args.
# Or simpler: validation.

def fix_constructor(content):
    # Find DsCustomMiddleWareRequest usage
    # We need to count commas inside the parentheses to see if it has 4 args.
    # This is hard with regex. 
    # But we can try to find the specific patterns used in tests.
    
    # Pattern 1: DsCustomMiddleWareRequest('GET', ..., ..., ...) -> DsCustomMiddleWareRequest('GET', ..., ..., ..., {})
    # Only target test files for this.
    
    # Let's iterate over matches.
    
    def replacer(match):
        full_match = match.group(0)
        # simplistic comma count (ignoring commas in strings/maps/lists for now, hopefully test code is simple)
        # The test code passes empty maps {} or simple strings.
        if full_match.count(',') == 3: # 4 args separated by 3 commas
             return full_match[:-1] + ', {})'
        return full_match

    # This regex tries to capture DsCustomMiddleWareRequest(...) call on a single line or spanned.
    # We will just try for single line first as most test lines looked like single line or simple breaking.
    # Test file step 471 shows:
    # var request = DsCustomMiddleWareRequest('GET',
    #       Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {});
    # This spans lines.
    
    # Approach: simple text replacement for the specific lines seen in error or generalized.
    # Error: Too few positional arguments: 5 required, 4 given.
    # We can assume if we see DsCustomMiddleWareRequest with 4 args, we add one.
    pass

print("Starting fix_remaining_issues.py...")

for d in dirs:
    for root, _, files in os.walk(d):
        for file in files:
            if file.endswith('.dart'):
                path = os.path.join(root, file)
                try:
                    with open(path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    new_content = content
                    
                    # Fix imports
                    for pat, repl in import_patterns:
                        new_content = re.sub(pat, repl, new_content)
                    
                    # Fix constructors only in test files
                    if 'test' in path:
                         # Regex to find DsCustomMiddleWareRequest instantiations
                         # We look for "DsCustomMiddleWareRequest(" and then try to find the closing ")" and count args.
                         # Since args might be complex, we can simply look for the ending "null" or "{}" that is the 4th arg and add ", {}".
                         # In routing_test.dart: ... null, );
                         new_content = re.sub(r'(DsCustomMiddleWareRequest\([^;]+null)(\s*\),?)', r'\1, {}\2', new_content)
                         # In ds_custom_middleware_test.dart: ... {}); );  (nested)
                         # var request = DsCustomMiddleWareRequest(..., {}, {});
                         # This one ends with });
                         # Regex: matching 4th arg being {} or null.
                         
                         # Specific fix for routing_test.dart which uses `null` as 4th arg.
                         new_content = re.sub(r'(DsCustomMiddleWareRequest\([^;]+,\s*null)(\s*\);)', r'\1, {}\2', new_content)
                         
                         # Specific fix for ds_custom_middleware_test.dart which uses `{}` as 4th arg.
                         # Pattern: DsCustomMiddleWareRequest(..., {}, {}) -> DsCustomMiddleWareRequest(..., {}, {}, {})
                         # It seems hard to match exactly with regex without parsing.
                         # Let's read the file line by line and if we find the constructor call, we inspect.
                         pass

                    if new_content != content:
                        with open(path, 'w', encoding='utf-8') as f:
                            f.write(new_content)
                        print(f"Updated imports/structure in {path}")
                        
                except Exception as e:
                    print(f"Failed to process {path}: {e}")

# Manual string replacement for known test patterns to be safe
test_files = [
    'test/ds_custom_middleware_test.dart',
    'test/routing/routing_test.dart'
]

for tf in test_files:
    if os.path.exists(tf):
        with open(tf, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # known pattern in routing_test.dart: 
        # null,
        #       );
        # We can replace "null," with "null, {}," if inside DsCustomMiddleWareRequest (context difficult).
        # But looking at file content:
        # line 27: null,
        # line 28: );
        
        # We can simply replace "null,\n      );" with "null, {},\n      );"
        new_content = content.replace("null,\n      );", "null, {},\n      );")
        
        # known pattern in ds_custom_middleware_test.dart:
        # {'Authorization': 'user1'}, {});
        # {}, {});
        # We want: {'Authorization': 'user1'}, {}, {});  (wait, body is 4th, queryParams is 5th)
        # If test passes 4 args: method, uri, headers, body.
        # So we need to add queryParams.
        
        # In ds_custom_middleware_test.dart:
        # DsCustomMiddleWareRequest('GET', Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {});
        # Replacement: DsCustomMiddleWareRequest('GET', Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {}, {});
        
        new_content = new_content.replace(
            "DsCustomMiddleWareRequest('GET',\n          Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {})",
            "DsCustomMiddleWareRequest('GET',\n          Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {}, {})"
        )
        
         # Another one:
        new_content = new_content.replace(
            "DsCustomMiddleWareRequest(\n          'GET', Uri.parse('/authenticated/resource'), {}, {})",
            "DsCustomMiddleWareRequest(\n          'GET', Uri.parse('/authenticated/resource'), {}, {}, {})"
        )

        # Another one in ds_custom_middleware_test.dart 
        # var request = DsCustomMiddleWareRequest('GET',
        #   Uri.parse('/authenticated/resource'), {'Authorization': 'user1'}, {});
        # Line 17-18. 
        # The replace above might handle it if whitespace matches.
        # Let's just handle it via more generic regex for the ending.
        
        # Replace "}, {});" with "}, {}, {});"
        # Only if it follows DsCustomMiddleWareRequest?
        # Safe enough for this test file.
        # new_content = new_content.replace("}, {});", "}, {}, {});") 
        # Wait, accidentally double replacing?
        
        if new_content != content:
             with open(tf, 'w', encoding='utf-8') as f:
                f.write(new_content)
             print(f"Fixed constructors in {tf}")

print("Done.")
