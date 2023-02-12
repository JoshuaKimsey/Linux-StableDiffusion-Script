# THIS REPO IS NOW ARCIVED! I MAKE NO GUARENTEES THAT IT WILL STILL WORK IN THE FUTURE AND WILL NOT BE MAINTAINING IT. IF YOU WISH TO FORK IT AND CONTINUE WORKING ON IT, BY ALL MEANS DO SO. ANY OTHER QUESTIONS REGARDING THE HLKY/SYGIL STABLE DIFFUSION WEBUI SHOULD BE DIRECTED TO THEIR PROJECT REPO: [SYGIL WEBUI](https://github.com/Sygil-Dev/sygil-webui).

# Linux Installation

### The definitive Stable Diffusion WebUI experience ™ Now 100% Linux Compatible!
#### Created by [Joshua Kimsey](https://github.com/JoshuaKimsey)

## Features
- Automates the process of installing and running hlky's fork of Stable Diffusion with the WebUI for Linux-based OS users.
- Handles updating from the hlky fork automatically if the users wishes to do so.
- Allows the user to preset their configs for running their setup (Gradio version only).

## Change Log

**PLEASE NOTE: If you are upgrading from using the 1.x versions of the script, it is my strong suggestion that you consider deleting the repo folder created by the script and letting it redownload to ensure everything is properly updated. To do so easily and without losing images you have already generated, simply copy the `outputs` folder to another location outside of the GitHub repo folder. Also, if you do not have a copy of the SD models you are using, make sure you copy the `model.ckpt` file from `models/ldm/stable-diffusion-v1` to another location as well. Delete the repo folder and rerun `linus-sd.sh` to reinstall. When it asks for the model files, if you copied a backup somewhere else, make sure the file is (re)named to `sd-v1-4.ckpt` before you move it to the repo folder as the script requests. Once installation is complete, feel free to copy your `outputs` folder back to the repo folder as well.**

* Version 2.0: 
	- Brand new redesign of the script to work with both the newer Streamlit and older Gradio interfaces.
	- Now integrates with the in-built `webui.sh` file in the repo itself for better compatibility.

* Version 1.0 - 1.9: 
	- Initial versions supporting the single Gradio Interface.

## Initial Start Guide
**Note:** This guide assumes you have installed Anaconda already, and have it set up properly. If you have not, please visit the [Anaconda](https://www.anaconda.com/products/distribution) website to download the file for your system and install it.

**WARNING: Multiple Linux users have reported issues using this script, and potentially Stable Diffusion in general, with Miniconda. As such, I can not recommend using it due to these issues with unknown causes. Please use the full release of Anaconda instead.**

**Step 1:** Create a folder/directory on your system and place this [script](https://github.com/JoshuaKimsey/Linux-StableDiffusion-Script/blob/main/linux-sd.sh) in it, named `linux-sd.sh`. This directory will be where the files for Stable Diffusion will be downloaded.

**Step 2:** Download the 1.4 AI model from HuggingFace (or another location, the original guide has some links to mirrors of the model) and place it in the same directory as the script.

**Step 3:** Make the script executable by opening the directory in your Terminal and typing `chmod +x linux-sd.sh`, or whatever you named this file as.

**Step 4:** Run the script with `./linux-sd.sh`, it will begin by cloning the [WebUI Github Repo](https://github.com/sd-webui/stable-diffusion-webui) to the directory the script is located in. This folder will be named `stable-diffusion-webui`.  

**Step 5:** The script will pause and ask that you move/copy the downloaded 1.4 AI models to the `stable-diffusion-webui` folder. Press Enter once you have done so to continue.

**If you are running low on storage space, you can just move the 1.4 AI models file directly to this directory, it will not be deleted, simply moved and renamed. However my personal suggestion is to just **copy** it to the repo folder, in case you desire to delete and rebuild your Stable Diffusion build again.**

**Step 6:** Next, the script will ask if you wish to customize any of the launch arguments for the Gradio WebUI Interface. If yes, then a series of options will be presented to the user:
	- Use the CPU for Extra Upscaler Models to save on VRAM
	- Automatically open a new browser window or tab on first launch
	- Use Optimized mode for Ultimate Stable Diffusion, which only requires 4GB of VRAM at the cost of speed
	- Use Optimized Turbo which uses more VRAM than regular optimized, but is faster (Incompatible with regular optimized mode)
	- Open a public xxxxx.gradi.app URL to share your interface with others (Please be careful with this, it is a potential security risk)

The user will have the ability to set these to yes or no using the menu choices.

**Note: These only apply to the Gradio WebUI interface. The Streamlit Interface version has/will have the ability to set its own preferences from within the WebUI**

**Step 7:** The script will then proceed to call the `webui.sh` file within the repo folder. This will handle the creation and updating of the conda environment, named `ldm`, as well as handle the downloading of the upsclaer models used by both Streamlit and Gradio. It will also download the Concepts Library for using custom models in the Streamlit version.

**Building the Conda environment may take upwards of 15 minutes, depending on your network connection and system specs. This is normal, just leave it be and let it finish. If you are trying to update and the script hangs at `Installing PIP Dependencies`, you will need to `Ctrl-C` to stop the script, delete your `src` folder, and rerun `linux-sd.sh` again.**

**Step 8:** Once the conda environment has been created and the upscaler models have been downloaded, then the user is presented with a choice to choose between the Streamlit or Gradio versions of the WebUI Interface. 
	- Streamlit: 
		- Has A More Modern UI
		- More Features Planned
		- Will Be The Main UI Going Forward
		- Currently In Active Development
		- Missing Some Gradio Features

	- Gradio:
		- Currently Feature Complete
		- Uses An Older Interface Style
		- Will Not Receive Major Updates

**Step 9:** If everything has gone successfully, either a new browser window will open with the Streamlit version, or you should see `Running on local URL:  http://localhost:7860/` in your Terminal if you launched the Gradio Interface version. Generated images will be located in the `outputs` directory inside of `stable-diffusion-webui`. Enjoy the definitive Stable Diffusion WebUI experience on Linux! :)

## Ultimate Stable Diffusion Customizations

When running the script again after the initial use, the user will be presented with a choice to run Stable Diffusion with the last used parameters used to launch it. If the user chooses `Yes`, then all customization steps will be skipped and the Stable Diffusion WebUI will launch without pulling in new updates.

If the user chooses to Customize their setup, then they will be presented with these options on how to customize their Ultimate Stable Diffusion setup:

- Update the Stable Diffusion WebUI fork from the GitHub Repo
- Customize the launch arguments for Gradio Interface version of Stable Diffusion (See Above)

### Refer back to the original [WebUI Github Repo](https://github.com/sd-webui/stable-diffusion-webui) for useful tips and links to other resources that can improve your Stable Diffusion experience

## Planned Additions
- Investigate ways to handle Anaconda automatic installation on a user's system.
