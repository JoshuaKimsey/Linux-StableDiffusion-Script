# ULTIMATE STABLE DIFFUSION GUI ON LINUX GUIDE

### The definitive Stable Diffusion experience ™ Now 100% Linux Compatible!
#### Created by [Joshua Kimsey](https://github.com/JoshuaKimsey)

#### Based on: [GUITARD](https://rentry.org/guitard) by [hlky](https://github.com/hlky)
(Please refer to there if something breaks or updates in Stable Diffusion itself, I will try to keep this guide updated as necessary)

## Features
- Automates the process of installing and running the hlky fork of Stable Diffusion for Linux-based OS users.
- Handles updating from the hlky fork automatically if the users wishes to do so.
- Allows the user to decide whether to run the Standard or Optimized forms of Ultimate Stable Diffusion.

## Change Log

**PLEASE NOTE: In order to upgrade to version 1.7 or later of this script, you must delete your pre-existing `ultimate-stable-diffusion` folder and do a clean re-install using the script. You can copy your `outputs` folder in there to save it elsewhere and then add it back once the re-install is done. Also, make sure your original 1.4 models are saved somewhere, or else you will need to re-download them from Hugging Face. The models file can be found in `ultimate-stable-diffusion/models/ldm/stablediffusion-v1/Model.ckpt`, if you do not have them saved elsewhere. Rename it to `sd-v1-4.ckpt` to make them work as expected with the script.**

**Please Note: Version 1.8 and above now make use of the unified Stable-Diffusion WebUI repo on GitHub. Your old outputs are safe in the `ultimate-stable-diffusion` folder as a new folder will be generated for this unified repo. Feel free to copy your outputs folder from `ultimate-stable-diffusion` over to the new `stable-diffusion-webui` folder. Don't forget the model weights inside of `ultimate-stable-diffusion` as well, if you don't have them saved elsewhere. Once this is done, you may safely delete the `ultimate-stable-diffusion` folder, as it is no longer used or needed.**

* Version 1.8:
	- Added: Support for newly unified {Stable Diffusion WebUI}(https://github.com/sd-webui/stable-diffusion-webui) GitHub repo.

* Version 1.7:
	- Added: New arguments manager for `relauncher.py`.
	- Added: Handling for LDSR upsclaer setup.
	- Changed: Significantly cleaned up menu options for handling customization.
    - Version 1.7.1: Changed repo updating to be less prone to issues

* Version 1.6:
	- Added: Improved startup procedure to speed up start to launch times
	- Fixed: Potential updating issue with the environment.yaml file

* Version 1.5:
	- Added: Ability to load previously used parameters, speeding up launch times.
	- Added: Foundations for loading in new Stable Diffusion AI Models once that becomes a reality.
	- Changed: Cleaned up script code significantly.

* Version 1.4:
	- Added: Choice to launch hlky's Ultimate Stable Diffusion using Standard mode for faster inference or Optimized mode for lower VRAM usage.
	- Fixed: Significantly cleaned up code and made things prettier when running the script.
	- Removed: Now unnecessary code for basuljindal's Optimized SD, now that hlky's version supports it instead.

* Version 1.3:
	- ~~Added: Foundation for choosing which version of Stable Diffusion you would like to install and run, Ultimate or Optimized.~~
	- Fixed: Code layout using functions now.
	- Broken: Optimized won't install correctly and I'm not sure why, currently a WIP. (Update: No Longer an issue)

* Version 1.2:
	- Added the ability to choose to update from the hlky SD repo at the start of the script.
	- Fixed potential env naming issue in generated script. Please delete your `linux-setup.sh` file inside of the stable-diffusion directory before running the new script

* Version 1.1:
	- Added support for realESRGAN feature added to the hlky GitHub repo

* Version 1.0: Initial Release

## Initial Start Guide
**Note:** This guide assumes you have installed Anaconda already, and have it set up properly. If you have not, please visit the [Anaconda](https://www.anaconda.com/products/distribution) website to download the file for your system and install it.

**WARNING: Multiple Linux users have reported issues using this script, and potentially Stable Diffusion in general, with Miniconda. As such, I can not recommend using it due to these issues with unknown causes. Please use the full release of Anaconda instead.**

**Step 1:** Create a folder/directory on your system and place this [script](https://github.com/JoshuaKimsey/Linux-StableDiffusion-Script/blob/main/linux-sd.sh) in it, named `linux-sd.sh`. This directory will be where the files for Stable Diffusion will be downloaded.

**Step 2:** Download the 1.4 AI model from HuggingFace (or another location, the original guide has some links to mirrors of the model) and place it in the same directory as the script.

**Step 3:** Run the script with `./linux-sd.sh`, it will begin by cloning the [WebUI Github Repo](https://github.com/sd-webui/stable-diffusion-webui) to the directory the script is located in. This folder will be named `stable-diffusion-webui`.

**Step 4:** The script will pause and ask that you move/copy the downloaded 1.4 AI models to a newly created, **temporary** directory called `Models`. Press Enter once you have done so to continue.

**If you are running low on storage space, you can just move the 1.4 AI models file directly to this directory, it will not be deleted, simply moved and renamed. However my personal suggestion is to just **copy** it to the Models folder, in case you desire to delete and rebuild your Ultimate Stable Diffusion build again.**

**Step 5:** The script will then proceed to generate the Conda environment for the project. It will be created using the name `lsd` (not a mistake ;) ), which is short for `Linux Stable Diffusion`.

**If a Conda environment of this name already exists, it will ask you before deleting it. If you do not wish to continue, press `CTRL-C` to exit the program. Otherwise, press Enter to continue.**

**Building the Conda environment may take upwards of 15 minutes, depending on your network connection and system specs. This is normal, just leave it be and let it finish.**

**Step 6:** Once the Conda environment has been created successfully, GFPGAN, realESRGAN, and LDSR upscaler models will be downloaded and placed in their correct location automatically.

**Step 7:** Next, the script will ask if you wish to customize any of the launch arguments for Ultimate Stable Diffusion. IF yes, then a series of options will be presented to the user:
	- Use the CPU for Extra Upscaler Models to save on VRAM
	- Automatically open a new browser window or tab on first launch
	- Use Optimized mode for Ultimate Stable Diffusion, which only requires 4GB of VRAM at the cost of speed
	- Use Optimized Turbo which uses more VRAM than regular optimized, but is faster (Incompatible with regular optimized mode)
	- Open a public xxxxx.gradi.app URL to share your interface with others

The user will have the ability to set these to yes or no using the menu choices.

**Step 8:** After this, the last step is the script will, at first launch, generate another script within the `ultimate-stable-diffusion` directory, which will be called via BASH in interactive mode to launch Stable Diffusion itself. This is necessary due to oddities with how Conda handles being executed from scripts. This second script launches the python file that begins to run the web gui for Ultimate Stable Diffusion.

**On first launch this process may take a bit longer than on successive runs, but shouldn't take as long as building the Conda environment did.**

**Step 9:** If everything has gone successfully, you should see `Running on local URL:  http://localhost:7860/` in your Terminal. Copy that and open it in your browser and you should now have access to the Gradio interface for Stable Diffusion! Generated images will be located in the `outputs` directory inside of `ultimate-stable-diffusion`.

**Step 10:** Enjoy the definitive Ultimate Stable Diffusion Experience on Linux!! :D

## Ultimate Stable Diffusion Customizations

When running the script again after the initial use, the user will be presented with a choice to run Ultimate Stable Diffusion with the last used parameters used to launch it. If the user chooses `Yes`, then all customization steps will be skipped and Ultimate Stable Diffusion will launch.

If the user choose to Customize their setup, then they will be presented with these options on how to customize their Ultimate Stable Diffusion setup:

- Update the Stable Diffusion WebUI fork from the GitHub Repo
- Load a new Stable Diffusion AI Model ==Currently Disabled. Will be enabled once multiple Stable Diffusion AI Models becomes a reality.==
- Customize the launch arguments for Ultimate Stable Diffusion (See Above)

### Refer back to the original [guide](https://rentry.org/guitard) (potentially outdated now) for useful tips and links to other resources that can improve your Stable Diffusion experience

## Planned Additions
- Investigate ways to handle Anaconda/Miniconda automatic installation on a user's system.
