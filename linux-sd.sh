#!/bin/bash

# Linux Stable Diffusion Script

# Version: 1.9

# MIT License

# Copyright (c) 2022 Joshua Kimsey

##### Please See My Guide For Running This Script Here: https://rentry.org/linux-sd #####

# Confirmed working as of September 9th, 2022. May be subject to breakage at a later date due to bleeding-edge updates in the Stable Diffusion WebUI repo
# Please see my GitHub for updates on this script: https://github.com/JoshuaKimsey/Linux-StableDiffusion-Script

printf "\n\n\n"
printf "WELCOME TO THE ULTIMATE STABLE DIFFUSION WEB GUI ON LINUX"
printf "\n\n"
printf "The definitive Stable Diffusion experience™ Now 100% Linux Compatible!"
printf "\n"
printf "Please ensure you have Anaconda installed properly on your Linux system before running this."
printf "\n"
printf "Please refer to the original guide for more info and additional links for this project: https://rentry.org/guitard"
printf "\n\n"

DIRECTORY=./stable-diffusion-webui
REPO=https://github.com/sd-webui/stable-diffusion-webui.git
ENV=lsd

ultimate_stable_diffusion_repo () {
    # Check to see if Ultimate Stable Diffusion repo is cloned
    if [ -d "$DIRECTORY" ]; then
        printf "\n\n########## CHECK FOR UPDATES ##########\n\n"
        printf "Ultimate Stable Diffusion already exists. Do you want to update Ultimate Stable Diffusion?"
        printf "(This will reset your launch arguments and they will need to be set again after updating)"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Pulling updates for Ultimate Stable Diffusion. Please wait..."; ultimate_stable_diffusion_repo_update; break;;
                No ) printf "Ultimate Stable Diffusion will not be updated. Continuing..."; break;;
            esac
        done
    else
        printf "Cloning Ultimate Stable Diffusion. Please wait..."
        git clone $REPO
        cp $DIRECTORY/scripts/relauncher.py $DIRECTORY/scripts/relauncher-backup.py
    fi
}

ultimate_stable_diffusion_repo_update () {
    cd $DIRECTORY
    git fetch --all
    git reset --hard origin/master
    cp ./scripts/relauncher.py ./scripts/relauncher-backup.py
    cp environment.yaml environment-backup.yaml
    sed -i 's/ldm/lsd/g' environment.yaml
    conda env update --file environment.yaml --prune
    cd ..;
}

sd_model_loading () {
    # Check to see if the 1.4 model already exists, if not then it creates it and prompts the user to add the 1.4 AI models to the Models directory
    if [ -f "$DIRECTORY/models/ldm/stable-diffusion-v1/model.ckpt" ]; then
        printf "AI Model already in place."
        # Will be enabled once new AI Models are released
        #sd_model_update
    else 
        mkdir Models
        printf "\n\n########## MOVE MODEL FILE ##########\n\n"
        printf "Please download the 1.4 AI Model from Huggingface (or another source) and move or copy it in the newly created directory: Models"
        read -p "Once you have sd-v1-4.ckpt in the Models directory, Press Enter..."
        
        # Check to make sure checksum of models is the original one from HuggingFace and not a fake model set
        printf "fe4efff1e174c627256e44ec2991ba279b3816e364b49f9be2abc0b3ff3f8556 ./Models/sd-v1-4.ckpt" | sha256sum --check || exit 1
        mv ./Models/sd-v1-4.ckpt $DIRECTORY/models/ldm/stable-diffusion-v1/model.ckpt
        rm -r ./Models
    fi
}

sd_model_update () {
    printf "\n\n########## Update Stable Diffusion Models ##########\n\n"
    printf "Do you wish to load a new/different Stable Diffusion AI Model?"
    printf "Warning: This will DELETE the pre-existing model.ckpt present in Ultimate Stable Diffusion!"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) printf "Preparing for new AI Model loading. Please wait..."; break;;
            No ) printf "Stable Diffusion AI model will not be updated. Continuing..."; break;;
        esac
    done
}

conda_env_setup () {
    # Checks to see if the appropriate conda environment has been setup.
    # If the environment hasn't been created yet, it will do so under the name "lsd" (Yes, I'm fully aware of that letter choice ;) )
    if [ -d "$DIRECTORY/src" ]; then
        printf "Conda environment already created. Continuing..."
    else
        printf "Creating conda environment for Linux StableDiffusion (LSD). Please wait..."
        if [[ $(conda env list | grep "$ENV") = $ENV* ]]; then
            printf "\n\n########## DELETE OLD CONDA ENVIRONMENT ##########\n\n" 
            printf "You already have a conda env called lsd, this will delete that environment and create a new one for Linux Stable Diffusion"
            read -p "If you do not wish to delete the conda env: lsd, please press CTRL-C. Otherwise, press Enter to continue..."
            conda env remove -n $ENV
        fi
        cp $DIRECTORY/environment.yaml $DIRECTORY/environment-backup.yaml
        sed -i 's/ldm/lsd/g' $DIRECTORY/environment.yaml
        conda env create -f $DIRECTORY/environment.yaml
    fi
}

post_processor_model_loading () {
    # Check to see if GFPGAN has been added yet, if not it will download it and place it in the proper directory
    if [ -f "$DIRECTORY/src/gfpgan/experiments/pretrained_models/GFPGANv1.3.pth" ]; then
        printf "GFPGAN already exists. Continuing..."
    else
        printf "Downloading GFPGAN model. Please wait..."
        wget https://github.com/TencentARC/GFPGAN/releases/download/v1.3.0/GFPGANv1.3.pth -P $DIRECTORY/src/gfpgan/experiments/pretrained_models
    fi

    # Check to see if realESRGAN has been added yet, if not it will download it and place it in the proper directory
    if [ -f "$DIRECTORY/src/realesrgan/experiments/pretrained_models/RealESRGAN_x4plus.pth" ]; then
        printf "realESRGAN already exists. Continuing..."
    else
        printf "Downloading realESRGAN model. Please wait..."
        wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.1.0/RealESRGAN_x4plus.pth -P $DIRECTORY/src/realesrgan/experiments/pretrained_models
        wget https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.2.4/RealESRGAN_x4plus_anime_6B.pth -P $DIRECTORY/src/realesrgan/experiments/pretrained_models
    fi

    # Check to see if LDSR has been added yet, if not it will be cloned and its models downloaded to the correct directory
    if [ -f "$DIRECTORY/src/latent-diffusion/experiments/pretrained_models/model.ckpt" ]; then
        printf "LDSR already exists. Continuing..."
    else
        printf "Cloning LDSR and downloading model. Please wait..."
        git clone https://github.com/devilismyfriend/latent-diffusion.git
        mv latent-diffusion $DIRECTORY/src/latent-diffusion
        mkdir $DIRECTORY/src/latent-diffusion/experiments
        mkdir $DIRECTORY/src/latent-diffusion/experiments/pretrained_models
        wget https://heibox.uni-heidelberg.de/f/31a76b13ea27482981b4/?dl=1 -P $DIRECTORY/src/latent-diffusion/experiments/pretrained_models
        mv $DIRECTORY/src/latent-diffusion/experiments/pretrained_models/index.html?dl=1 $DIRECTORY/src/latent-diffusion/experiments/pretrained_models/project.yaml
        wget https://heibox.uni-heidelberg.de/f/578df07c8fc04ffbadf3/?dl=1 -P $DIRECTORY/src/latent-diffusion/experiments/pretrained_models
        mv $DIRECTORY/src/latent-diffusion/experiments/pretrained_models/index.html?dl=1 $DIRECTORY/src/latent-diffusion/experiments/pretrained_models/model.ckpt
    fi
}

linux_setup_script () {
    # Checks to see if the main Linux bash script exists in the stable-diffusion repo.
    # If it does, it executes using bash in interactive mode due to issues with conda activation
    # If it does not exist, it generates the file and makes it executable
    if [ -f "$DIRECTORY/linux-setup.sh" ]; then
        cd $DIRECTORY
        printf "Running linux-setup.sh..."
        bash -i ./linux-setup.sh
    else
        printf "Generating linux-setup.sh in $DIRECTORY"
        touch $DIRECTORY/linux-setup.sh
        chmod +x $DIRECTORY/linux-setup.sh
        printf "#!/bin/bash\n\n#MIT License\n\n#Copyright (c) 2022 Joshua Kimsey\n\n\n##### CONDA ENVIRONMENT ACTIVATION #####\n\n# Activate The Conda Environment\nconda activate lsd\n\n\n##### PYTHON HANDLING #####\n\npython scripts/relauncher.py" >> $DIRECTORY/linux-setup.sh
        cd $DIRECTORY
        printf "Running linux-setup.sh..."
        bash -i ./linux-setup.sh
    fi
}

# Checks to see which mode Ultimate Stable Diffusion is running in: STANDARD or OPTIMIZED
# Then asks the user which mode they wish to use
ultimate_stable_diffusion_arguments () {
    if [ "$1" = "customize" ]; then
        printf "\n\n"
        printf "Do you want extra upscaling models to be run on the CPU instead of the GPU to save on VRAM at the cost of speed?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting extra upscaling models to use the CPU..."; sed -i 's/extra_models_cpu = False/extra_models_cpu = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Extra upscaling models will run on the GPU. Continuing..."; sed -i 's/extra_models_cpu = True/extra_models_cpu = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want for Ultimate Stable Diffusion to automatically launch a new browser window or tab on first launch?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to open a new browser window/tab at first launch..."; sed -i 's/open_in_browser = False/open_in_browser = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Ultimate Stable Diffusion will not open automatically in a new browser window/tab. Continuing..."; sed -i 's/open_in_browser = True/open_in_browser = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to run Ultimate Stable Diffusion in Optimized mode - Requires only 4GB of VRAM, but is significantly slower?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to run in Optimized Mode..."; sed -i 's/optimized = False/optimized = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Ultimate Stable Diffusion will launch in Standard Mode. Continuing..."; sed -i 's/optimized = True/optimized = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to start Ultimate Stable Diffusion in Optimized Turbo mode - Requires more VRAM than regular optimized, but is faster (incompatible with Optimized Mode)?"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to run in Optimized Turbo mode..."; sed -i 's/optimized_turbo = False/optimized_turbo = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Ultimate Stable Diffusion will launch in Standard Mode. Continuing..."; sed -i 's/optimized_turbo = True/optimized_turbo = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to create a public xxxxx.gradi.app URL to allow others to uses your interface? (Requires properly forwarded ports)"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to open a public share URL..."; sed -i 's/share = False/share = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Setting Ultimate Stable Diffusion to not open a public share URL. Continuing..."; sed -i 's/share = True/share = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\nCustomization of Ultimate Stable Diffusion is complete. Continuing...\n\n"
    else
        printf "\n\n########## CUSTOMIZE LAUNCH ARGUMENTS ##########\n\n"
        printf "Do you wish to customize the launch arguments for Ultimate Stable Diffusion?"
        printf "(This will be where you select Optimized mode, auto open in browser, share to public, and more.)"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Starting customization of Ultimate Stable Diffusion launch arguments..."; ultimate_stable_diffusion_arguments customize; break;;
                No ) printf "Maintaining current launch arguments..."; break;;
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
        ultimate_stable_diffusion_arguments
        linux_setup_script
    else
        if [[ $(conda env list | grep "$ENV") = $ENV* ]]; then
            printf "\n\n########## RUN PREVIOUS SETUP ##########\n\n"
            printf "Do you wish to run Ultimate Stable Diffusion with the previous parameters?"
            printf "(Select NO to customize or update your Ultimate Stable Diffusion setup)"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) printf "Starting Ultimate Stable Diffusion using previous parameters. Please wait..."; linux_setup_script; break;;
                    No ) printf "Beginning customization of Ultimate Stable Diffusion..."; ultimate_stable_diffusion initial; break;;
                esac
            done
        else
            printf "ERROR: Conda Env not found. Will attempt to rebuild, please go through the update steps below..."
            ultimate_stable_diffusion initial
        fi
    fi
}

# Initialization 
if [ ! -d "$DIRECTORY" ]; then
    printf "Starting Ultimate Stable Diffusion installation..."
    printf "\n"
    ultimate_stable_diffusion initial
else
    ultimate_stable_diffusion
fi
