#!/usr/bin/env python

import sys
import os
import yaml
import isbnlib

metafile = sys.argv[1]
metadata = open(metafile, 'r').read()
yamldata = yaml.load(metadata)

identifier = {}

for id in yamldata["identifier"]:
    if "key" in id:
        isbnlike = isbnlib.get_isbnlike(id["text"])[0]
        if isbnlib.is_isbn13(isbnlike):
            identifier[id["key"]] = isbnlib.EAN13(isbnlike)

isbn = identifier[sys.argv[2]]

if len(sys.argv) >= 4 and sys.argv[3] == "mask":
    print(isbnlib.mask(isbn))
else:
    print(isbn)