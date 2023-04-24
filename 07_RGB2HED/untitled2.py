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
from tabulate import tabulate
import os

print(skimage.__version__)

rgbimg = np.array(Image.open("PDL1_SP142_4/TNBC_Block_4_block_1_314921_3_I_PD-L1_SP142.png"))
hedimg = skimage.color.rgb2hed(rgbimg)

image = Image.fromarray(hedimg.astype('uint8')).convert('RGB')
image.save('TEST.jpg')