# README Bioinformatics Project
### Felicia Schulz
### Supervisors: Johan Staaf, Suze Julia Roostee
### BINP37, 15 credits


The aim of this project was to investigate the role of the biomarker programmed death ligand 1 (PD-L1) in triple-negative breast cancer (TNBC). This was done by using a pre-trained convolutional neural network on own data and evaluate its prediction accuracy.

The model was created by Shamai et al. (2022) and can be found in https://github.com/aleju/imgaug.

## Repository structure and general workflow
To follow the workflow of this project, first, the machine learning model must be run on own image data. Download the necessary files from https://github.com/aleju/imgaug and run as specified. 

Before running the model, some pre-processing steps had to be carried out which are described in this README.
The output of the model is a prediction textfile, here called output.txt.
This file can then be used to evaluate the output with the scripts found in folder 01 in this repository.
Then, a survival analysis can be carried out with the scripts found in folder 02.
Finally, the immunohistochemistry images have to be converted to HED image space, which can be done using the scripts in folder 03. This concludes this project.

If further analyses want to be carried out, one can get inspired by the contents of folder 04.


## Applying the model

### Installation requirements
In this project, the machine learning model was run in a conda environment. The environment was run using conda v23.1.10 and python v3.9. A comprehensive environment.yaml file can be found in this repository.

The machine used in this project did not have a GPU which is why the PyTorch packages were installed with the CPU-only compatible version with the soumith flag.

```bash
conda install pytorch=1.10.2 -c soumith
conda install torchvision=0.11.3 -c soumith
conda install -c conda-forge opencv==4.5.5
conda install tqdm==4.64.0
```

### Pre-processing of the data
The image files had to be renamed because of spaces in the file names.
```bash
# Count number of images
ls | wc -l #598
# Count number of images that have space in name
ls | grep " " | wc -l #247
# for example TNBC_Block_1_block_1_229588_1_A_HTX .png

ls | while read line; do name=$(echo $line | cut -d " " -f 1 | tr -d "\n") ; mv ${name}" .png" ${name}.png; done
```

The images also had to be converted from png to jpg because the machine learning network requires jpg format. This was done using ImageMagick v7.0.10-43.

```bash
# convert images
ls | while read line; do name=$(echo $line | cut -d "." -f 1 | tr -d "\n") ; magick ${name}.png ${name}.jpg ; done
# add to separate folder
ls | grep ".jpg" | while read line; do name=$(echo $line | tr -d "\n") ; mv $name ../HTX_jpg ; done
```


In order to run the script predict_on_folder.py from https://github.com/aleju/imgaug, because of the lack of GPU, this line of code had to be changed in the predict_on_folder.py file.
```python
#Previously: checkpoint = torch.load(args.model_path)
checkpoint = torch.load(args.model_path, map_location=torch.device('cpu'))
```

### Running the model
The model was run in the command line with the following code. 
```bash
python3 predict_on_folder.py ../HTX_jpg --output_file output.txt
```

## 01_PDL1_Performance_Analysis
This folder contains a script for merging the different data files needed, called edit_data.R.
An example of this output is in the file merged_PDL1stained.csv. This is also the input file for the main evaluation analysis carried out by the script pdl1_output_analysis.R.

This script creates plots for evaluating the performance of the machine learning network compared to the pathologist labels. An example output plot can also be found in this directory. The output plot will contain one scatterplot and one confusion matrix heat map.


## 02_Survival_Analysis
This folder contains a script called survival_analysis.R which creates survival plots from one survival data file and one file with PDL1 prediction scores and classes. One example for such an input file would be the file merged_PDL1stained.csv from folder 01. 

There is also an example output plot.

The survival data was not added in this GitHub repository for data privacy reaasons.

## 03_RGB2HED
In this project, not only H&E-stained images were used as input data for the machine learning neural network, but also immunohistochemistry Ventana SP142 stained images. However, those need to be converted to HED colour space in order to resemble the H&E input data more.

This can be done with the script rgb2hed.py.

### Translation of images from RGB to HED using Scikit-image
Scikit-image was used with version v0.20.0.
The script is run in the following way:
```bash
conda install scikit-image 
# alternative install:
python -m pip install -U scikit-image
python -c "import skimage; print(skimage.__version__)" # check if it exists
ls ALL_PDL1/ | while read line; do python3 rgb2hed.py ALL_PDL1 $line; done
```

In addition to this script, there is also a script called show_four_layers.py which creates an image with the three layers of HED and the original image and saves it to the current working directory. 

An example of output that is created is also in this folder.


## 04_Fine_Tuning
The analysis that was started in this folder was outside of the scope of this project.
It was done solely out of interest because this is a possible future direction of this project.
The notebook in this folder is unfinished.

If one is interested in how fine tuning could look at, this is a work in progress showing that.











