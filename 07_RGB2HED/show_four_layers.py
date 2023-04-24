#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 18 14:49:51 2023

@author: fschulz
"""

import numpy as np
from skimage.color import rgb2hed
from PIL import Image
import numpy as np
import skimage
#from tabulate import tabulate
#import os
import matplotlib.pyplot as plt
from skimage import data
from skimage.color import rgb2hed, hed2rgb
import imageio

print(skimage.__version__)

rgbimg = np.array(Image.open("PDL1_SP142_4/TNBC_Block_4_block_1_314921_3_I_PD-L1_SP142.png"))
hedimg = skimage.color.rgb2hed(rgbimg)

image = Image.fromarray(rgbimg)
image.save('TEST.jpg')

# Example IHC image
ihc_rgb = rgbimg



# Separate the stains from the IHC image
ihc_hed = rgb2hed(ihc_rgb)
print("beforehed = ", ihc_hed.shape, ihc_hed.dtype)

"""
# Create an RGB image for each of the stains
null = np.zeros_like(ihc_hed[:, :, 0])
ihc_h = hed2rgb(np.stack((ihc_hed[:, :, 0], null, null), axis=-1))
ihc_e = hed2rgb(np.stack((null, ihc_hed[:, :, 1], null), axis=-1))
ihc_d = hed2rgb(np.stack((null, null, ihc_hed[:, :, 2]), axis=-1))

# Display
fig, axes = plt.subplots(2, 2, figsize=(7, 6), sharex=True, sharey=True)
ax = axes.ravel()

ax[0].imshow(ihc_rgb)
ax[0].set_title("Original image")

ax[1].imshow(ihc_h)
ax[1].set_title("Hematoxylin")

ax[2].imshow(ihc_e)
ax[2].set_title("Eosin")  # Note that there is no Eosin stain in this image

ax[3].imshow(ihc_d)
ax[3].set_title("DAB")

for a in ax.ravel():
    a.axis('off')

fig.tight_layout()

plt.savefig("allfour.png")
"""
# Create an RGB image for Hematoxylin stain
null = np.zeros_like(ihc_hed[:, :, 0])
ihc_h = hed2rgb(np.stack((ihc_hed[:, :, 0], null, null), axis=-1))



print("h = ", ihc_h.shape, ihc_h.dtype)
print("rgb = ", rgbimg.shape, rgbimg.dtype)

print(np.amax(ihc_h), np.amin(ihc_h))





# normalize the array to have values between 0 and 1
hed_norm = ihc_h / np.max(ihc_h)

# convert the array to uint8
arr_uint8 = (hed_norm * 255).astype(np.uint8)

# create an Image object from the uint8 array and save it
img = Image.fromarray(arr_uint8, mode='RGB')
img.save('output.jpg')



