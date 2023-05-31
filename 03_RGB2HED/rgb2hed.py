#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Author: fschulz

Usage: python3 rgb2hed.py <folder_name> <image_name>

This script takes a RGB image and converts it to HED colour space.
Then, the H-layer is extracted and the image is saved to the current working directory
with the same name as before (given the extension was .jpg).
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

# For getting H and E layers instead, uncomment this line:
#hedimg_h = hed2rgb(np.stack((hedimg[:, :, 0], hedimg[:, :, 1], null), axis=-1))


# Make hed_h into uint8 from float64 so that it can be saved with PIL Image
h_norm = hedimg_h / np.max(hedimg_h) # normalize the array to have values between 0 and 1
h_uint8 = (h_norm * 255).astype(np.uint8) # convert the array to uint8
h_img = Image.fromarray(h_uint8, mode='RGB') # create an Image object from the uint8 array and save it
h_img.save('Output_folder/{}.jpg'.format(name))

print("Hematoxylin image {} saved.".format(name))



