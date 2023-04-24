#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 18 11:05:25 2023

@author: fschulz

Usage: python3 rgb2hed.py <folder_name> <image_name>
"""
import sys
import numpy as np
from PIL import Image
from skimage.color import rgb2hed, hed2rgb

folder = sys.argv[1]
image = sys.argv[2]
name = image.split(".")[0]

# Converting RGB to HED
rgbimg = np.array(Image.open("{}/{}".format(folder, image)))
hedimg = rgb2hed(rgbimg)

# Separating hematoxylin from hed layers, converting hematoxylin stain layer back to RGB
null = np.zeros_like(hedimg[:, :, 0])
hedimg_h = hed2rgb(np.stack((hedimg[:, :, 0], null, null), axis=-1))

# Make hed_h into uint8 from float64 so that it can be saved with PIL Image
h_norm = hedimg_h / np.max(hedimg_h) # normalize the array to have values between 0 and 1
h_uint8 = (h_norm * 255).astype(np.uint8) # convert the array to uint8
h_img = Image.fromarray(h_uint8, mode='RGB') # create an Image object from the uint8 array and save it
h_img.save('Output_folder/{}.jpg'.format(name))

print("Hematoxylin image {} saved.".format(name))



