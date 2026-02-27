import os
import re

files_to_process = [
    'lib/screens/listings/listing_detail_screen.dart',
    'lib/screens/listings/create_listing_screen.dart',
    'lib/screens/trades/trade_detail_screen.dart',
    'lib/screens/profile/credit_history_screen.dart'
]

import_statement = "import '../../widgets/translated_text.dart';\n"
trade_import_statement = "import '../../widgets/translated_text.dart';\n" # adjusting relative paths

for filepath in files_to_process:
    if not os.path.exists(filepath):
        continue
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Check if already imported
    if "translated_text.dart" not in content:
        # Add import after other imports
        lines = content.split('\n')
        last_import_idx = -1
        for i, line in enumerate(lines):
            if line.startswith("import "):
                last_import_idx = i
                
        if last_import_idx != -1:
            lines.insert(last_import_idx + 1, import_statement)
            content = '\n'.join(lines)
            
    # Replace all 'Text(' with 'TranslatedText(' except in comments or if it's already TranslatedText
    # We will use a regex. But we must be careful not to replace `RichText(text: TextSpan(` 
    # The grep searched for ' Text(' or 'Text('. Wait, Dart widget is `Text( `.
    # We can replace r'(?<!Translated)Text\(' with r'TranslatedText('
    
    # Let's do a safe replacement of word boundary \bText\(
    new_content = re.sub(r'\bText\(', 'TranslatedText(', content)
    
    # We might have `TranslatedTranslatedText` if we ran it twice or if it replaced 'TranslatedText'
    new_content = new_content.replace('TranslatedTranslatedText(', 'TranslatedText(')
    
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(new_content)
        
print("Replacement script completed.")
