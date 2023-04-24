#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Apr  6 15:07:32 2023

@author: fschulz
"""
import re

with open("output_hematoxylin.txt", "r") as data:
    mllist = []
    for line in data:
        name = line.split(" ")[0].strip()
        name = line.split("_")
        mllist.append(name[6])

  
with open("PDL1scores.csv", "r") as path_data:
    pathlist = []
    path_data.readline()
    for line in  path_data:
        name = line.split(",")[6].strip()
        #survname_re = re.sub('[^0-9]', '', survname)
        name_number = name.split("_")
        pathlist.append(name_number[5])

        
pathlist.sort()
mllist.sort()

#%%

for name in pathlist:
    if name in mllist:
        print(name)

previous = pathlist[0]
lastconnected = 0
connected = True
for name in pathlist:
    print(name, connected)
    if connected == True:
        if int(previous)+1 == int(name):
            print(previous, name)
            previous = name
            continue
        else:
            lastconnected = name
            previous = name
            connected = False
            continue
    elif connected == False:
        if int(previous)+1 == int(name):
            connected = True
            againconnected = name
            print("gap:", lastconnected, "-", againconnected)
            previous = name
            continue
        else:
            previous = name
            continue
            
        
        

