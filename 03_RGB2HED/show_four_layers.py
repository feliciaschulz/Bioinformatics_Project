#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Felicia Schulz

This script uses the skimage package to create an image of the three layers 
of the HED converted image.

The image is saved to the current working directory.
"""

import numpy as np
from PIL import Image
import skimage #v0.20.0
import matplotlib.pyplot as plt
from skimage.color import rgb2hed, hed2rgb

print(skimage.__version__)

# Load image
rgbimg = np.array(Image.open("TNBC_Block_3_block_1_314258_4_I_PD-L1_SP142.jpg"))

# Separate the stains from the IHC image
ihc_hed = rgb2hed(rgbimg)


# Create an RGB image for each of the stains
null = np.zeros_like(ihc_hed[:, :, 0])
ihc_h = hed2rgb(np.stack((ihc_hed[:, :, 0], null, null), axis=-1))
ihc_e = hed2rgb(np.stack((null, ihc_hed[:, :, 1], null), axis=-1))
ihc_d = hed2rgb(np.stack((null, null, ihc_hed[:, :, 2]), axis=-1))
ihc_he = hed2rgb(np.stack((ihc_hed[:, :, 0], ihc_hed[:, :, 1], null), axis=-1))

# Display layers
fig, axes = plt.subplots(2, 2, figsize=(7, 6), sharex=True, sharey=True)
ax = axes.ravel()

ax[0].imshow(rgbimg)
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

# Save image
plt.savefig("allfourTEST.png")

