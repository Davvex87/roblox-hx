import re

def extract_unique_hx_classes(file_path):
    pattern = re.compile(r'_hxClasses\["([^"]+)"\]')
    found_classes = set()
    class_blacklist = [
        'Array',
        'Date',
        'EReg',
        'IntIterator',
        'Lambda',
        'Math',
        'Reflect',
        'String',
        'Std',
        'StringBuf',
        'StringTools',
        'ValueType',
        'Type',
	]

    with open(file_path, 'r', encoding='utf-8') as file:
        for line in file:
            match = pattern.search(line)
            if match:
                class_name = match.group(1)
                if class_name not in found_classes and class_name not in class_blacklist:
                    found_classes.add(class_name)
                    print("\"" + class_name + "\",")

extract_unique_hx_classes('Std.lua')