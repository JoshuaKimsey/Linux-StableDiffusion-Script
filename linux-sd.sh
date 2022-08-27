#!/bin/bash

# Linux Stable Diffusion Script

# Version: 1.2

#MIT License

#Copyright (c) 2022 Joshua Kimsey

##### Please See My Guide For Running This Script Here: (Link) #####

#Confirmed working as of August 26th, 2022. May be subject to breakage at a later date due to bleeding-edge updates in the StableDiffusion fork repo
# Please see my GitHub gist for updates on this script: 

echo "WELCOME TO THE ULTIMATE STABLE DIFFUSION GUI ON LINUX"
echo "The definitive Stable Diffusion experience™ Now 100% Linux Compatible!"
echo "Please ensure you have Anaconda installed properly on your Linux system before running this."
echo "Please refer to the original guide for more info and additional links for this project: https://rentry.org/guitard"


# Check to see if SD repo is cloned
# This currently uses the fork by hlky, may be changed to main Optimized SD fork later on
if [ -d "./stable-diffusion" ]; then
    echo "Optimized StableDiffusion already exists. Do you want to update Stable Diffusion?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) echo "Cloning Optimized StableDiffusion. Please wait..."; cd stable-diffusion; git pull; conda env update --file environment.yaml --prune; cd ..; break;;
            No ) echo "Stable Diffusion will not be updated. Continuing..."; break;;
        esac
    done
else
    echo "Cloning Optimized StableDiffusion. Please wait..."
    git clone https://github.com/hlky/stable-diffusion
fi

# Check to see if the 1.4 model already exists, if not then it creates it and prompts the user to add the 1.4 AI models to the Models directory
if [ -f "./stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt" ]; then
    echo "AI Model already in place. Continuing..."
else 
    mkdir Models

    echo "Please download the 1.4 AI Model from Huggingface (or another source) and place/copy it in the newly created directory: Models"
    read -p "Once you have sd-v1-4.ckpt in the Models directory, Press Enter..."

    mv ./Models/sd-v1-4.ckpt ./stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt
    rm -r ./Models
fi

# Checks to see if the appropriate conda environment has been setup.
# If the environment hasn't been created yet, it will do so under the name "lsd" (Yes, I'm fully aware of that letter choice ;) )
if [ -d "./stable-diffusion/src" ]; then
    echo "Conda environment already created. Continuing..."
else
    echo "Creating conda environment for Linux StableDiffusion (LSD). Please wait..."
    if [[ $(conda env list | grep 'lsd') = lsd* ]]; then 
        echo "You already have a conda env called lsd, this will delete that environment and create a new one for Linux StableDiffusion"
        read -p "If you do not wish to delete the conda env: lsd, please press CTRL-C. Otherwise, press Enter to continue..."
        conda env remove -n lsd
    fi
    sed -i 's/ldm/lsd/g' ./stable-diffusion/environment.yaml
    conda env create -f ./stable-diffusion/environment.yaml
fi

# Check to see if GFPGAN has been added yet, if not it will download it and place it in the proper directory
if [ -f "./stable-diffusion/src/gfpgan/experiments/pretrained_models/GFPGANv1.3.pth" ]; then
    echo "GFPGAN already exists. Continuing..."
else
    echo "Downloading GFPGAN model. Please wait..."
    wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P ./stable-diffusion/src/gfpgan/experiments/pretrained_models
fi

# Check to see if realESRGAN has been added yet, if not it will download it and place it in the proper directory
if [ -f "./stable-diffusion/src/realesrgan/experiments/pretrained_models/RealESRGAN_x4plus.pth" ]; then
    echo "realESRGAN already exists. Continuing..."
else
    echo "Downloading realESRGAN model. Please wait..."
    wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P ./stable-diffusion/src/realesrgan/experiments/pretrained_models
    wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P ./stable-diffusion/src/realesrgan/experiments/pretrained_models
fi

# Checks to see if the main Linux bash script exists in the stable-diffusion repo.
# If it does, it executes using bash in interactive mode due to issues with conda activation
# If it does not exist, it generates the file and makes it executable
if [ -f "./stable-diffusion/linux-setup.sh" ]; then
    echo "Running linux-setup.sh..."
    cd stable-diffusion
    bash -i ./linux-setup.sh
else
    echo "Generating linux-setup.sh in ./stable-diffusion"
    touch ./stable-diffusion/linux-setup.sh
    chmod +x ./stable-diffusion/linux-setup.sh
    printf "#!/bin/bash\n\n#MIT License\n\n#Copyright (c) 2022 Joshua Kimsey\n\n\n##### CONDA ENVIRONMENT ACTIVATION #####\n\n# Activate The Conda Environment\nconda activate lsd\n\n\n##### PYTHON HANDLING #####\n\n#Check to see if model exists in the correct location with the correct name, exit if it does not.\npython scripts/relauncher.py" >> ./stable-diffusion/linux-setup.sh
    echo "Running linux-setup.sh..."
    cd stable-diffusion
    bash -i ./linux-setup.sh
fi