import xml.etree.ElementTree as ET
import sys

date = sys.argv[2]

tree = ET.parse(sys.argv[1])
root = tree.getroot()
bucket_name = root[0].text
objects_to_restore = []
object_key = ""
object_lmd = ""
object_scl = ""
for elem in root.iter("{http://s3.amazonaws.com/doc/2006-03-01/}Contents"):
    object_key = ""
    object_lmd = ""
    object_scl = ""
    for content in elem:    
        if content.tag == "{http://s3.amazonaws.com/doc/2006-03-01/}Key":
            object_key = content.text
        elif content.tag == "{http://s3.amazonaws.com/doc/2006-03-01/}LastModified":
            object_lmd = content.text.split("T")[0]
            if object_lmd < date:
                object_lmd = ""
        elif content.tag == "{http://s3.amazonaws.com/doc/2006-03-01/}StorageClass" and content.text in ["GLACIER", "ACCELERATED"]:
            object_scl = content.text
    if object_key != "" and object_lmd != "" and object_scl != "":
        objects_to_restore.append(object_key)

file_path = bucket_name+"-objects.txt"
with open(file_path, "w") as f:
    for object in objects_to_restore:
        f.write(object+" ")
    f.close