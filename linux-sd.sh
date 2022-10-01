#!/bin/bash -i

# Linux Stable Diffusion Script

# Version: 2.0

# MIT License

# Copyright (c) 2022 Joshua Kimsey

##### Please See My Guide For Running This Script Here: https://rentry.org/linux-sd #####

# Confirmed working as of September 22nd, 2022. May be subject to breakage at a later date due to bleeding-edge updates in the Stable Diffusion WebUI repo
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
ENV=ldm

ultimate_stable_diffusion_repo () {
    # Check to see if Ultimate Stable Diffusion repo is cloned
    if [ -d "$DIRECTORY" ]; then
        printf "\n\n########## CHECK FOR UPDATES ##########\n\n"
        printf "Ultimate Stable Diffusion already exists. Do you want to update Ultimate Stable Diffusion?\n"
        printf "(This will reset your launch arguments and they will need to be set again after updating)\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Pulling updates for the Stable Diffusion WebUI. Please wait...\n"; ultimate_stable_diffusion_repo_update; break;;
                No ) printf "Stable Diffusion WebUI will not be updated. Continuing...\n"; break;;
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
    cd ..;
}

linux_setup_script () {
    cd $DIRECTORY
    printf "Running webui.sh...\n\n"
    bash -i ./webui.sh
}

# Checks to see which mode Ultimate Stable Diffusion is running in: STANDARD or OPTIMIZED
# Then asks the user which mode they wish to use
gradio_stable_diffusion_arguments () {
    if [ "$1" = "customize" ]; then
        printf "Do you want extra upscaling models to be run on the CPU instead of the GPU to save on VRAM at the cost of speed?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting extra upscaling models to use the CPU...\n"; sed -i 's/extra_models_cpu = False/extra_models_cpu = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Extra upscaling models will run on the GPU. Continuing...\n"; sed -i 's/extra_models_cpu = True/extra_models_cpu = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want for Ultimate Stable Diffusion to automatically launch a new browser window or tab on first launch?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to open a new browser window/tab at first launch...\n"; sed -i 's/open_in_browser = False/open_in_browser = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Ultimate Stable Diffusion will not open automatically in a new browser window/tab. Continuing...\n"; sed -i 's/open_in_browser = True/open_in_browser = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to run Ultimate Stable Diffusion in Optimized mode - Requires only 4GB of VRAM, but is significantly slower?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to run in Optimized Mode...\n"; sed -i 's/optimized = False/optimized = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Ultimate Stable Diffusion will launch in Standard Mode. Continuing...\n"; sed -i 's/optimized = True/optimized = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to start Ultimate Stable Diffusion in Optimized Turbo mode - Requires more VRAM than regular optimized, but is faster (incompatible with Optimized Mode)?\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to run in Optimized Turbo mode...\n"; sed -i 's/optimized_turbo = False/optimized_turbo = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Ultimate Stable Diffusion will launch in Standard Mode. Continuing...\n"; sed -i 's/optimized_turbo = True/optimized_turbo = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\n"
        printf "Do you want to create a public xxxxx.gradi.app URL to allow others to uses your interface? (Requires properly forwarded ports)\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Setting Ultimate Stable Diffusion to open a public share URL...\n"; sed -i 's/share = False/share = True/g' $DIRECTORY/scripts/relauncher.py; break;;
                No ) printf "Setting Ultimate Stable Diffusion to not open a public share URL. Continuing...\n"; sed -i 's/share = True/share = False/g' $DIRECTORY/scripts/relauncher.py; break;;
            esac
        done
        printf "\n\nCustomization of Ultimate Stable Diffusion is complete. Continuing...\n\n"
    else
        printf "\n\n########## GRADIO CUSTOMIZATION ##########\nPlease Note: These Arguments Only Affect The Gradio Interface Version Of The Stable Diffusion Webui.\n\n"
        printf "Do you wish to customize the launch arguments for the Gradio Webui Interface?\n"
        printf "(This will be where you select Optimized mode, auto open in browser, share to public, and more.)\n"
        select yn in "Yes" "No"; do
            case $yn in
                Yes ) printf "Starting customization of Gradio Interface launch arguments...\n"; gradio_stable_diffusion_arguments customize; break;;
                No ) printf "Maintaining current Gradio Interface launch arguments...\n"; break;;
            esac
        done
    fi    
}

# Function to install and run the Ultimate Stable Diffusion fork
ultimate_stable_diffusion () {
    if [ "$1" = "initial" ]; then
        ultimate_stable_diffusion_repo
        gradio_stable_diffusion_arguments
        linux_setup_script
    else
        if [[ $(conda env list | grep "$ENV") = $ENV* ]]; then
            printf "\n\n########## RUN PREVIOUS SETUP ##########\n\n"
            printf "Do you wish to run Ultimate Stable Diffusion with the previous parameters?\n"
            printf "(Select NO to customize or update your Ultimate Stable Diffusion setup)\n"
            select yn in "Yes" "No"; do
                case $yn in
                    Yes ) printf "Starting Ultimate Stable Diffusion using previous parameters. Please wait..."; linux_setup_script; break;;
                    No ) printf "Beginning customization of Ultimate Stable Diffusion..."; ultimate_stable_diffusion initial; break;;
                esac
            done
        else
            printf "ERROR: Conda Env not found. Will attempt to rebuild, please go through the update steps below...\n"
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
