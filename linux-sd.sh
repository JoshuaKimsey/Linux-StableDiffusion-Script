#!/bin/bash

# Linux Stable Diffusion Script

# Version: 1.6

# MIT License

# Copyright (c) 2022 Joshua Kimsey

##### Please See My Guide For Running This Script Here: https://rentry.org/linux-sd #####

# Confirmed working as of August 31th, 2022. May be subject to breakage at a later date due to bleeding-edge updates in hlky's Stable Diffusion fork repo
# Please see my GitHub gist for updates on this script: 

printf "\n\n\n"
echo "WELCOME TO THE ULTIMATE STABLE DIFFUSION GUI ON LINUX"
printf "\n\n"
echo "The definitive Stable Diffusion experience™ Now 100% Linux Compatible!"
printf "\n"
echo "Please ensure you have Anaconda installed properly on your Linux system before running this."
printf "\n"
echo "Please refer to the original guide for more info and additional links for this project: https://rentry.org/guitard"
printf "\n\n"

DIRECTORY=./ultimate-stable-diffusion

ultimate_stable_diffusion_repo () {
    # Check to see if Ultimate Stable Diffusion repo is cloned
    if [ -d "$DIRECTORY" ]; then
        printf "\n\n########## CHECK FOR UPDATES ##########\n\n"
        echo "Ultimate Stable Diffusion already exists. Do you want to update Ultimate Stable Diffusion?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) echo "Pulling updates for Ultimate Stable Diffusion. Please wait..."; ultimate_stable_diffusion_repo_update; break;;
                No ) echo "Ultimate Stable Diffusion will not be updated. Continuing..."; break;;
            esac
        done
    else
        echo "Cloning Ultimate Stable Diffusion. Please wait..."
        git clone https://github.com/hlky/stable-diffusion
        mv stable-diffusion ultimate-stable-diffusion
    fi
}

ultimate_stable_diffusion_repo_update () {
    cd $DIRECTORY
    rm environment.yaml
    mv environment-backup.yaml environment.yaml
    git pull
    cp environment.yaml environment-backup.yaml
    sed -i 's/ldm/lsd/g' environment.yaml
    conda env update --file environment.yaml --prune
    cd ..;
}

sd_model_loading () {
    # Check to see if the 1.4 model already exists, if not then it creates it and prompts the user to add the 1.4 AI models to the Models directory
    if [ -f "$DIRECTORY/models/ldm/stable-diffusion-v1/model.ckpt" ]; then
        echo "AI Model already in place."
        # Will be enabled once new AI Models are released
        #sd_model_update
    else 
        mkdir Models

        printf "\n\n########## MOVE MODEL FILE ##########\n\n"
        echo "Please download the 1.4 AI Model from Huggingface (or another source) and move or copy it in the newly created directory: Models"
        read -p "Once you have sd-v1-4.ckpt in the Models directory, Press Enter..."

        echo "fe4efff1e174c627256e44ec2991ba279b3816e364b49f9be2abc0b3ff3f8556 ./Models/sd-v1-4.ckpt" | sha256sum --check || exit 1
        mv ./Models/sd-v1-4.ckpt $DIRECTORY/models/ldm/stable-diffusion-v1/model.ckpt
        rm -r ./Models
    fi
}

sd_model_update () {
    printf "\n\n########## Update Stable Diffusion Models ##########\n\n"
    echo "Do you wish to load a new/different Stable Diffusion AI Model?"
    echo "Warning: This will DELETE the pre-existing model.ckpt present in Ultimate Stable Diffusion!"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) echo "Preparing for new AI Model loading. Please wait..."; break;;
            No ) echo "Stable Diffusion AI model will not be updated. Continuing..."; break;;
        esac
    done
}

conda_env_setup () {
    # Checks to see if the appropriate conda environment has been setup.
    # If the environment hasn't been created yet, it will do so under the name "lsd" (Yes, I'm fully aware of that letter choice ;) )
    if [ -d "$DIRECTORY/src" ]; then
        echo "Conda environment already created. Continuing..."
    else
        echo "Creating conda environment for Linux StableDiffusion (LSD). Please wait..."
        if [[ $(conda env list | grep 'lsd') = lsd* ]]; then
            printf "\n\n########## DELETE OLD CONDA ENVIRONMENT ##########\n\n" 
            echo "You already have a conda env called lsd, this will delete that environment and create a new one for Linux Stable Diffusion"
            read -p "If you do not wish to delete the conda env: lsd, please press CTRL-C. Otherwise, press Enter to continue..."
            conda env remove -n lsd
        fi
        cp $DIRECTORY/environment.yaml $DIRECTORY/environment-backup.yaml
        sed -i 's/ldm/lsd/g' $DIRECTORY/environment.yaml
        conda env create -f $DIRECTORY/environment.yaml
    fi
}

post_processor_model_loading () {
    # Check to see if GFPGAN has been added yet, if not it will download it and place it in the proper directory
    if [ -f "$DIRECTORY/src/gfpgan/experiments/pretrained_models/GFPGANv1.3.pth" ]; then
        echo "GFPGAN already exists. Continuing..."
    else
        echo "Downloading GFPGAN model. Please wait..."
        wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P $DIRECTORY/src/gfpgan/experiments/pretrained_models
    fi

    # Check to see if realESRGAN has been added yet, if not it will download it and place it in the proper directory
    if [ -f "$DIRECTORY/src/realesrgan/experiments/pretrained_models/RealESRGAN_x4plus.pth" ]; then
        echo "realESRGAN already exists. Continuing..."
    else
        echo "Downloading realESRGAN model. Please wait..."
        wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P $DIRECTORY/src/realesrgan/experiments/pretrained_models
        wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P $DIRECTORY/src/realesrgan/experiments/pretrained_models
    fi
}

linux_setup_script () {
    # Checks to see if the main Linux bash script exists in the stable-diffusion repo.
    # If it does, it executes using bash in interactive mode due to issues with conda activation
    # If it does not exist, it generates the file and makes it executable
    if [ -f "$DIRECTORY/linux-setup.sh" ]; then
        cd ultimate-stable-diffusion
        echo "Running linux-setup.sh..."
        bash -i ./linux-setup.sh
    else
        echo "Generating linux-setup.sh in $DIRECTORY"
        touch $DIRECTORY/linux-setup.sh
        chmod +x $DIRECTORY/linux-setup.sh
        printf "#!/bin/bash\n\n#MIT License\n\n#Copyright (c) 2022 Joshua Kimsey\n\n\n##### CONDA ENVIRONMENT ACTIVATION #####\n\n# Activate The Conda Environment\nconda activate lsd\n\n\n##### PYTHON HANDLING #####\n\n#Check to see if model exists in the correct location with the correct name, exit if it does not.\npython scripts/relauncher.py" >> $DIRECTORY/linux-setup.sh
        cd ultimate-stable-diffusion
        echo "Running linux-setup.sh..."
        bash -i ./linux-setup.sh
    fi
}

# Checks to see which mode Ultimate Stable Diffusion is running in: STANDARD or OPTIMIZED
# Then asks the user which mode they wish to use
ultimate_stable_diffusion_mode () {
    if [[ ! $(cat $DIRECTORY/scripts/relauncher.py | grep 'optimized') ]]; then
        printf "\n\n########## CHOOSE ULTIMATE STABLE DIFFUSION MODE ##########\n\n"
        echo "Ultimate Stable Diffusion is currently running in STANDARD mode."
        echo "This results in faster inference times, at the cost of more VRAM usage (6GB minimum)."
        printf "\n"
        echo "Alternatively, you can run Ultimate Stable Diffusion in OPTIMIZED mode."
        echo "This results in it being able to run on only 4GB of VRAM, at the cost of slower inference times."
        printf "\n"
        echo "Would you like to run Ultimate Stable Diffusion in STANDARD or OPTIMIZED mode?"
        select yn in "Standard" "Optimized"; do
            case $yn in
                Standard ) echo "Launching in standard mode."; break;;
                Optimized ) echo "Setting Ultimate Stable Diffusion to optimized mode..."; sed -i 's/python scripts\/webui.py/python scripts\/webui.py --gfpgan-cpu --esrgan-cpu --optimized/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
    else
        printf "\n\n########## CHOOSE ULTIMATE STABLE DIFFUSION MODE ##########\n\n"
        echo "Ultimate Stable Diffusion is currently running in OPTIMIZED mode."
        echo "This results in it being able to run on only 4GB of VRAM, at the cost of slower inference times."
        printf "\n"
        echo "Alternatively, you can run Ultimate Stable Diffusion in OPTIMIZED mode."
        echo "This results in faster inference times, at the cost of more VRAM usage (6GB minimum)."
        printf "\n"
        echo "Would you like to run Ultimate Stable Diffusion in STANDARD or OPTIMIZED mode?"
        select yn in "Standard" "Optimized"; do
            case $yn in
                Standard ) echo "Setting Ultimate Stable DIffusion to standard mode..."; sed -i 's/python scripts\/webui.py --gfpgan-cpu --esrgan-cpu --optimized/python scripts\/webui.py/g' $DIRECTORY/scripts/relauncher.py; break;;
                Optimized ) echo "Launching in optimized mode."; break;;
            esac
        done
    fi
}

# Function to install and run the Ultimate Stable Diffusion fork
ultimate_stable_diffusion () {
    if [ "$1" = "initial" ]; then
        ultimate_stable_diffusion_repo
        sd_model_loading
        conda_env_setup
        post_processor_model_loading
        ultimate_stable_diffusion_mode
        linux_setup_script
    else
        printf "\n\n########## RUN PREVIOUS SETUP ##########\n\n"
        if [[ ! $(cat $DIRECTORY/scripts/relauncher.py | grep 'optimized') ]]; then
            printf "Ultimate Stable Diffusion is set to run in: STANDARD MODE\n\n"
        else
            printf "Ultimate Stable Diffusion is set to run in: OPTIMIZED MODE\n\n"
        fi
        echo "Do you wish to run Ultimate Stable Diffusion with the previous parameters?"
        echo "(Select NO to customize or update your Ultimate Stable Diffusion setup)"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) echo "Starting Ultimate Stable Diffusion using previous parameters. Please wait..."; linux_setup_script; break;;
                No ) echo "Beginning customization of Ultimate Stable Diffusion..."; ultimate_stable_diffusion initial; break;;
            esac
        done
    fi
}

# Initialization 
if [ ! -d "$DIRECTORY" ]; then
    echo "Starting Ultimate Stable Diffusion installation..."
    printf "\n"
    ultimate_stable_diffusion initial
else
    ultimate_stable_diffusion
fi
