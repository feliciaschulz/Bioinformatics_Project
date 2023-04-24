# README Bioinformatics Project
## Felicia Schulz
## Supervisors: Johan Staaf, Suze Julia Roostee

Installing requirements for DL PD-L1 model
Using conda 23.1.0, installing things in the environment python3.8version because python 3.8 is needed for this version of opencv.
```bash
pip3 install --upgrade setuptools pip
pip3 install --user opencv_python==4.5.5.64
conda install pytorch=1.10.2 -c soumith
conda install torchvision=0.11.3 -c soumith
pip3 install tqdm==4.64.0

#actually decided to install everything with conda
conda install -c conda-forge opencv==4.5.5
conda install tqdm==4.64.0
````

Have to rename all the png files to get rid of the space
```bash
# Count number of images
ls | wc -l #598
# Count number of images that have space in name
ls | grep " " | wc -l #247
# for example TNBC_Block_1_block_1_229588_1_A_HTX .png

ls | while read line; do name=$(echo $line | cut -d " " -f 1 | tr -d "\n") ; mv ${name}" .png" ${name}.png; done
```

Convert from png to jpg using ImageMagick 7.0.10-43
```bash
# convert images
ls | while read line; do name=$(echo $line | cut -d "." -f 1 | tr -d "\n") ; magick ${name}.png ${name}.jpg ; done
# add to separate folder
ls | grep ".jpg" | while read line; do name=$(echo $line | tr -d "\n") ; mv $name ../HTX_jpg ; done
```

Try to run ML model (not working yet)
```bash
python3 predict_on_folder.py ../HTX_jpg --output_file output.txt
```
Error: TypeError: Instance and class checks can only be used with @runtime_checkable protocols
Has to do with torch, doesn't have support for python 3.10 yet -> have to downgrade to 3.9

Was using python=3.10.10
Failure installing python=3.9

System conflicts in using python=3.9:
- feature:/osx-64::__osx==10.14.6=0
- feature:/osx-64::__unix==0=0
- feature:|@/osx-64::__osx==10.14.6=0
- feature:|@/osx-64::__unix==0=0
- opencv==4.5.5 -> qtwebkit=5 -> __osx[version='>=10.12']
- pysocks==1.7.1 -> __unix
- pysocks==1.7.1 -> __win
- urllib3==1.26.14 -> pysocks[version='>=1.5.6,<2.0,!=1.5.7'] -> __unix
- urllib3==1.26.14 -> pysocks[version='>=1.5.6,<2.0,!=1.5.7'] -> __win

Tried re-installing torch with nightly version like this: 
```bash
pip3 install --pre torch torchvision --index-url https://download.pytorch.org/whl/nightly/cpu
```
This version is supposed to comply with python=3.10. However, after installing this, got errors with ML code because lack of GPU.


### Wednesday 5/4
Using conda env python3.9. Installed python=3.9 first, then all dependencies from requirements.txt as specified at the top with conda.
Now running code, gives this error:
RuntimeError: Attempting to deserialize object on a CUDA device but torch.cuda.is_available() is False. If you are running on a CPU-only machine, please use torch.load with map_location=torch.device('cpu') to map your storages to the CPU.
Fix suggested in https://stackoverflow.com/questions/56369030/runtimeerror-attempting-to-deserialize-object-on-a-cuda-device:
```bash
# Inside code predict_on_folder.py
# Previously: checkpoint = torch.load(args.model_path)
checkpoint = torch.load(args.model_path, map_location=torch.device('cpu'))
```

### Might need this: https://github.com/scikit-image/scikit-image/issues/5164

### Scikit-image: Translation of images from rgb to HED
```bash
conda install scikit-image #(did pip in the end on the server)
python -m pip install -U scikit-image
# check for version
python -c "import skimage; print(skimage.__version__)"
ls ALL_PDL1/ | while read line; do python3 rgb2hed.py ALL_PDL1 $line; done
```

### Re-run machine learning model with hematoxylin images
```bash
python3 predict_on_folder.py ../Output_folder --output_file output_hematoxylin.txt
```













