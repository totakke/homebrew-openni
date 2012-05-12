# openni-formula

This project is for installing OpenNI, NITE, and sensor module with Homebrew.

This OpenNI formula depends on libusb-freenect.
The default libusb installed with Homebrew is not working on OpenNI.
libusb-freenect is for libfreenect library and works.

## Usage

### Prepare

    $ cd /usr/local/Library/Formula
    $ curl --insecure -O "https://raw.github.com/totakke/openni-formula/master/openni.rb"
    $ curl --insecure -O "https://raw.github.com/totakke/openni-formula/master/sensor.rb"
    $ curl --insecure -O "https://raw.github.com/OpenKinect/libfreenect/master/platform/osx/homebrew/libusb-freenect.rb"

### Install

Install __stable__ release:

    $ brew install openni
    $ brew install sensor
    
Install __unstable__ release:

    $ brew install --devel openni
    $ brew install --devel sensor
    
### Uninstall

    $ brew uninstall openni