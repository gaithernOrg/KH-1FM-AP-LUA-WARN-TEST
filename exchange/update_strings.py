import os
path = "./"

def replace_bytes(findstring, replacestr, path):
    for subdirectory, directory, files in os.walk(path):
        for file in files:
            if file.startswith("AP") and (file.endswith(".ev") or file.endswith("bin")):
                with open(subdirectory + "/" + file, "rb") as f:
                    s = f.read()
                    index = s.find(findstring)
                    if index > -1:
                        replaced_str = s.replace(findstring, replacestr)
                        new_file_name = file
                        new_path = "./" + subdirectory + "/"
                        with open(new_path + new_file_name, "wb") as f:
                            f.write(replaced_str)

findstring = b'\x97\x2B\x3A\x01\x33\x58\x49\x51'
replacestr = b'\x97\x01\x33\x58\x49\x51\x01\x01'
replace_bytes(findstring, replacestr, path)
findstring = b'\x2B\x3A\x01\x33\x58\x49\x51'
replacestr = b'\x97\x01\x33\x58\x49\x51\x01'
replace_bytes(findstring, replacestr, path)
findstring = b'\x2B\x3A\x33\x58\x49\x51'
replacestr = b'\x97\x01\x33\x58\x49\x51'
replace_bytes(findstring, replacestr, path)