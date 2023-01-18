import xml.etree.ElementTree as ET
import sys
tree = ET.parse(sys.argv[1])
root = tree.getroot()

# for child in root:
#     print(child.tag, child.attrib)
buckets = ""
for elem in root.iter("{http://s3.amazonaws.com/doc/2006-03-01/}Name"):
    buckets += elem.text
    buckets += " "

with open("buckets.txt", "w") as f:
    f.write(buckets)
    f.close()

# x = [elem.tag for elem in root.iter()]
# print(x)