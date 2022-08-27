#!/bin/bash

# Linux Stable Diffusion Script

# Version: 1.3

#MIT License

#Copyright (c) 2022 Joshua Kimsey

##### Please See My Guide For Running This Script Here: (Link) #####

#Confirmed working as of August 27th, 2022. May be subject to breakage at a later date due to bleeding-edge updates in the StableDiffusion fork repo
# Please see my GitHub gist for updates on this script: 

echo "WELCOME TO THE ULTIMATE STABLE DIFFUSION GUI ON LINUX"
echo "The definitive Stable Diffusion experience™ Now 100% Linux Compatible!"
echo "Please ensure you have Anaconda installed properly on your Linux system before running this."
echo "Please refer to the original guide for more info and additional links for this project: https://rentry.org/guitard"

function initial_startup {
    echo "No Stable Diffusion instance exists. Which would you like to install?"
    echo "Ultimate: Fully featured version that requires at minimum 6GB of VRAM, though likely needs closer to 8GB."
    echo "Optimized (Currently Not Working): Designed with older hardware in mind. Only requires 4GB of VRAM at the cost of inference speed."
    select yn in "Ultimate" "Optimized"; do
        case $yn in
            Ultimate ) ultimate_stable_diffusion; break;;
            Optimized ) optimized_stable_diffusion; break;;
        esac
    done
}

function normal_startup {
    echo "A Stable Diffusion instance already exists. Which would you like to run?"
    echo "Note: If you select one that is not installed yet, it will automatically begin installing that version for you."
    select yn in "Ultimate" "Optimized"; do
        case $yn in
            Ultimate ) ultimate_stable_diffusion; break;;
            Optimized ) optimized_stable_diffusion; break;;
        esac
    done
}

# Function to install and run the Ultimate Stable Diffusion fork
function ultimate_stable_diffusion {
    # Check to see if Ultimate Stable Diffusion repo is cloned
    if [ -d "./ultimate-stable-diffusion" ]; then
        echo "Ultimate Stable Diffusion already exists. Do you want to update Ultimate Stable Diffusion?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) echo "Pulling updates for Ultimate Stable Diffusion. Please wait..."; cd ultimate-stable-diffusion; git pull; conda env update --file environment.yaml --prune; cd ..; break;;
                No ) echo "Ultimate Stable Diffusion will not be updated. Continuing..."; break;;
            esac
        done
    else
        echo "Cloning Ultimate Stable Diffusion. Please wait..."
        git clone https://github.com/hlky/stable-diffusion
        mv stable-diffusion ultimate-stable-diffusion
    fi

    # Check to see if the 1.4 model already exists, if not then it creates it and prompts the user to add the 1.4 AI models to the Models directory
    if [ -f "./ultimate-stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt" ]; then
        echo "AI Model already in place. Continuing..."
    else 
        mkdir Models

        echo "Please download the 1.4 AI Model from Huggingface (or another source) and move or copy it in the newly created directory: Models"
        read -p "Once you have sd-v1-4.ckpt in the Models directory, Press Enter..."

        mv ./Models/sd-v1-4.ckpt ./ultimate-stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt
        rm -r ./Models
    fi

    # Checks to see if the appropriate conda environment has been setup.
    # If the environment hasn't been created yet, it will do so under the name "lsd" (Yes, I'm fully aware of that letter choice ;) )
    if [ -d "./ultimate-stable-diffusion/src" ]; then
        echo "Conda environment already created. Continuing..."
    else
        echo "Creating conda environment for Linux StableDiffusion (LSD). Please wait..."
        if [[ $(conda env list | grep 'lsd') = lsd* ]]; then 
            echo "You already have a conda env called lsd, this will delete that environment and create a new one for Linux StableDiffusion"
            read -p "If you do not wish to delete the conda env: lsd, please press CTRL-C. Otherwise, press Enter to continue..."
            conda env remove -n lsd
        fi
        sed -i 's/ldm/lsd/g' ./ultimate-stable-diffusion/environment.yaml
        conda env create -f ./ultimate-stable-diffusion/environment.yaml
    fi

    # Check to see if GFPGAN has been added yet, if not it will download it and place it in the proper directory
    if [ -f "./ultimate-stable-diffusion/src/gfpgan/experiments/pretrained_models/GFPGANv1.3.pth" ]; then
        echo "GFPGAN already exists. Continuing..."
    else
        echo "Downloading GFPGAN model. Please wait..."
        wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P ./ultimate-stable-diffusion/src/gfpgan/experiments/pretrained_models
    fi

    # Check to see if realESRGAN has been added yet, if not it will download it and place it in the proper directory
    if [ -f "./ultimate-stable-diffusion/src/realesrgan/experiments/pretrained_models/RealESRGAN_x4plus.pth" ]; then
        echo "realESRGAN already exists. Continuing..."
    else
        echo "Downloading realESRGAN model. Please wait..."
        wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P ./ultimate-stable-diffusion/src/realesrgan/experiments/pretrained_models
        wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P ./ultimate-stable-diffusion/src/realesrgan/experiments/pretrained_models
    fi

    # Checks to see if the main Linux bash script exists in the stable-diffusion repo.
    # If it does, it executes using bash in interactive mode due to issues with conda activation
    # If it does not exist, it generates the file and makes it executable
    if [ -f "./ultimate-stable-diffusion/linux-setup.sh" ]; then
        echo "Running linux-setup.sh..."
        cd ultimate-stable-diffusion
        bash -i ./linux-setup.sh
    else
        echo "Generating linux-setup.sh in ./ultimate-stable-diffusion"
        touch ./ultimate-stable-diffusion/linux-setup.sh
        chmod +x ./ultimate-stable-diffusion/linux-setup.sh
        printf "#!/bin/bash\n\n#MIT License\n\n#Copyright (c) 2022 Joshua Kimsey\n\n\n##### CONDA ENVIRONMENT ACTIVATION #####\n\n# Activate The Conda Environment\nconda activate lsd\n\n\n##### PYTHON HANDLING #####\n\n#Check to see if model exists in the correct location with the correct name, exit if it does not.\npython scripts/relauncher.py" >> ./ultimate-stable-diffusion/linux-setup.sh
        echo "Running linux-setup.sh..."
        cd ultimate-stable-diffusion
        bash -i ./linux-setup.sh
    fi
}

# Function to install and run the Optimized Stable Diffusion fork
function optimized_stable_diffusion {

    echo "Sorry, this is currently broken. Check back for an update"
    exit;

    # Check to see if Optimized Stable Diffusion repo is cloned
    if [ -d "./optimized-stable-diffusion" ]; then
        echo "optimized Stable Diffusion already exists. Do you want to update optimized Stable Diffusion?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) echo "Pulling updates for Optimized Stable Diffusion. Please wait..."; cd optimized-stable-diffusion; git pull; conda env update --file environment.yaml --prune; cd ..; break;;
                No ) echo "optimized Stable Diffusion will not be updated. Continuing..."; break;;
            esac
        done
    else
        echo "Cloning optimized Stable Diffusion. Please wait..."
        git clone https://github.com/hlky/stable-diffusion
        mv stable-diffusion optimized-stable-diffusion
    fi

    # Check to see if the 1.4 model already exists, if not then it creates it and prompts the user to add the 1.4 AI models to the Models directory
    if [ -f "./optimized-stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt" ]; then
        echo "AI Model already in place. Continuing..."
    else 
        mkdir Models

        echo "Please download the 1.4 AI Model from Huggingface (or another source) and move or copy it in the newly created directory: Models"
        read -p "Once you have sd-v1-4.ckpt in the Models directory, Press Enter..."

        mv ./Models/sd-v1-4.ckpt ./optimized-stable-diffusion/models/ldm/stable-diffusion-v1/model.ckpt
        rm -r ./Models
    fi

    # Checks to see if the appropriate conda environment has been setup.
    # If the environment hasn't been created yet, it will do so under the name "losd"
    if [ -d "./optimized-stable-diffusion/src" ]; then
        echo "Conda environment already created. Continuing..."
    else
        echo "Creating conda environment for Linux Optimized Stable Diffusion (LOSD). Please wait..."
        if [[ $(conda env list | grep 'losd') = losd* ]]; then 
            echo "You already have a conda env called losd, this will delete that environment and create a new one for Linux Stable Diffusion"
            read -p "If you do not wish to delete the conda env: losd, please press CTRL-C. Otherwise, press Enter to continue..."
            conda env remove -n losd
        fi
        sed -i 's/ldm/losd/g' ./optimized-stable-diffusion/environment.yaml
        conda env create -f ./optimized-stable-diffusion/environment.yaml
    fi

    # Checks to see if the main Linux bash script exists in the stable-diffusion repo.
    # If it does, it executes using bash in interactive mode due to issues with conda activation
    # If it does not exist, it generates the file and makes it executable
    if [ -f "./optimized-stable-diffusion/linux-setup.sh" ]; then
        echo "Running linux-setup.sh..."
        cd optimized-stable-diffusion
        bash -i ./linux-setup.sh
    else
        echo "Generating linux-setup.sh in ./optimized-stable-diffusion"
        touch ./optimized-stable-diffusion/linux-setup.sh
        chmod +x ./optimized-stable-diffusion/linux-setup.sh
        printf "#!/bin/bash\n\n#MIT License\n\n#Copyright (c) 2022 Joshua Kimsey\n\n\n##### CONDA ENVIRONMENT ACTIVATION #####\n\n# Activate The Conda Environment\nconda activate losd\npip install gradio\n\n\n##### PYTHON HANDLING #####\n\necho 'Do you wish to run the Optimized Stable Diffusion txt2img or img2img?'\nselect yn in 'txt2img' 'img2img'; do\ncase \$yn in\ntxt2img ) python optimizedSD/txt2img_gradio.py; break;;\nimg2img ) python optimizedSD/img2img_gradio.py;break;;\nesac\ndone" >> ./optimized-stable-diffusion/linux-setup.sh
        echo "Running linux-setup.sh..."
        cd optimized-stable-diffusion
        bash -i ./linux-setup.sh
    fi
}

if [ ! -d "./ultimate-stable-diffusion" ]; then 
    if [[ ! -d "./optimized-stable-diffusion" ]]; then 
        initial_startup
    fi 
else 
    normal_startup 
fi