[![Build Status](https://travis-ci.org/treehouses/builder.svg?branch=master)](https://travis-ci.org/treehouses/builder) [![Maintainability](https://api.codeclimate.com/v1/badges/748aa39277c63aa17d1a/maintainability)](https://codeclimate.com/github/treehouses/builder/maintainability) [![Gitter](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/treehouses/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

# builder

`builder` is based on [Raspbian](https://www.raspbian.org/) and
allows the user to develop and tailor their own custom Raspberry Pi images.
The script will modify the latest Raspbian image by installing packages,
purging packages and executing custom commands, and then finally
creates a bootable .img file that can be burned to the microSD card.

## Instructions

These instructions will get you a copy of the project up and
running on your local machine for development and testing purposes.

### Prerequisites

System requirements:

* Operating System - Debian/Ubuntu
* microSD card reader
* class10 microSD card (minimum 8 Gb)
* Packages - kpartx wget gpg parted qemu-arm-static

Note:

To install the required packages, run the following command in Debian/Ubuntu:

```bash
sudo apt-get install kpartx wget gpg parted qemu-arm-static.
```

For other operating systems like MacOS or Windows, check out the `Vagrantfile` inside the repository.

### Getting Started

```
git clone https://github.com/treehouses/builder.git
cd builder
./builder --chroot
```

You should be in a chrooted environment when it is completed.
You can access the RPi images' files and folders or carry on with any extra modifications.
To exit the chrooted environment just type `exit` and
then you should be back in your own shell again.
The image in this stage is now ready to write to the microSD card.

### Add gpg key

```bash
sudo bash -c 'wget -O - https://packagecloud.io/gpg.key | apt-key add -'
```

### Customize

* `INSTALL_PACKAGES` - Install packages found in the APT repositories.

  * To add a custom package not found in the default APT repositories:
    add the package name into `INSTALL_PACKAGES`,
    then add the custom repository to `ADD_REPOS`.

* `PURGE_PACKAGES` - Remove packages already installed on the default Raspbian image.

* `CUSTOM_COMMANDS` - Add extra commands to execute upon the completion of
  the `builder`, which is run under a chroot environment.

  * For instance, to enable ssh on boot for the RPi,
    the command `sudo touch /boot/ssh` is included in `CUSTOM_COMMANDS`.
    The semi-colon is there to separate the commands and
    will execute regardless whether or not the previous command is successful.

### Retrieve builds

After exiting from the chroot environment, successful builds
are found in the `builder/images` directory.
There should be a few files in that directory.
The .zip file is the unmodified base image,
which is downloaded by the script when executed.
The .img file is the new customized image and
is now ready to be burned onto the microSD card.

#### To remove unwanted modifications otherwise

`bash clean.sh`

### Write to microSD card and try out the image

We will need a few hardware and software:

* Raspberry Pi 3/4 (or Zero W)
* 5V 2.4A/3A (1.2A for Pi Zero) power supply with microUSB connector
* A microSD card reader
* A [Class 10](https://www.sdcard.org/developers/overview/speed_class/index.html)
  microSD card (minimal 8GB, but we strongly recommend 16GB or greater)
* Software for burning OS image to microSD card. We recommend [Etcher](https://etcher.io),
  but there are many from which to choose

Open Etcher, select the location of the .img file,
the destination drive of the microSD card,
then press the flash button to write the image onto the microSD card.
Remember that this process will wipe out everything on the selected drive,
so make sure to select the right one.

## Release

This project use Travis CI to automatically build and upload new treehouse image
to [http://dev.ole.org](http://dev.ole.org). `.travis.yml` configuration file
tells Travis CI to run the deployment script at `.travis/deploy.sh`
if a tag is applied to the commit.

* New image's name will be `treehouse-` followed by
  whatever is after `release-` in the tag
* New image's SHA-1 checksum will be calculated and uploaded as `<image_name>.img.gz.sha1`
* If the tag is formated like `release-` followed by only numbers,
  `latest.img.gz` and `latest.img.gz.sha1` would be a symbolic link of
  the newly uploaded image and its SHA-1 checksum
* At this time, both `stable.img.gz` and `branch.img.gz` on [http://dev.ole.org](http://dev.ole.org)
  are manually linked to their specific image
