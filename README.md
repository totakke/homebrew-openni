# openni-formula

This project is for installing OpenNI, NITE, and sensor module with Homebrew.

This OpenNI formula depends on libusb-freenect.
The default libusb installed with Homebrew is not working on OpenNI.
libusb-freenect is for libfreenect library and works.

## Usage

### Prepare

First, download related formulas:

    $ cd /usr/local/Library/Formula
    $ curl --insecure -O "https://raw.github.com/totakke/openni-formula/master/openni.rb"
    $ curl --insecure -O "https://raw.github.com/totakke/openni-formula/master/sensor.rb"
    $ curl --insecure -O "https://raw.github.com/totakke/openni-formula/master/nite.rb"
    $ curl --insecure -O "https://raw.github.com/OpenKinect/libfreenect/master/platform/osx/homebrew/libusb-freenect.rb"

If you want to use Kinect sensor (not Xtion), download sensor-kinect.rb instead of sensor.rb:

    $ curl --insecure -O "https://raw.github.com/totakke/openni-formula/master/sensor-kinect.rb"

### Install

Install OpenNI, Sensor (or SensorKinect), and NITE with Homebrew.

    $ brew install openni
    $ brew install sensor (or $ brew install sensor-kinect)
    $ brew install nite

If you want to install unstable release, add option "--devel". 

You have to setup manually after Homebrew installation.  
First, register modules.

    $ sudo mkdir -p /var/lib/ni
    $ sudo niReg /usr/local/lib/libnimMockNodes.dylib
    $ sudo niReg /usr/local/lib/libnimCodecs.dylib
    $ sudo niReg /usr/local/lib/libnimRecorder.dylib
    $ sudo niReg /usr/local/lib/libXnDeviceSensorV2.dylib /usr/local/etc/primesense
    $ sudo niReg /usr/local/lib/libXnDeviceFile.dylib /usr/local/etc/primesense
    $ sudo niReg /usr/local/lib/libXnVFeatures_1_5_2.dylib /usr/etc/primesense/Features_1_5_2
    $ sudo niReg /usr/local/lib/libXnVHandGenerator_1_5_2.dylib /usr/etc/primesense/Hands_1_5_2
    
Then, create a log directory for XnSensorServer, and enable it to be accessed by all users.

    $ sudo mkdir -p /var/log/primesense/XnSensorServer
    $ sudo chmod a+w /var/log/primesense/XnSensorServer

Finally, register license of NITE.

	$ sudo niLicense PrimeSense 0KOIk2JeIBYClPWVnMoRKn5cdY4=
    
    
### Uninstall

Unregister modules manually.

	$ sudo niReg -u /usr/local/lib/libnimMockNodes.dylib
    $ sudo niReg -u /usr/local/lib/libnimCodecs.dylib
    $ sudo niReg -u /usr/local/lib/libnimRecorder.dylib
    $ sudo niReg -u /usr/local/lib/libXnDeviceSensorV2.dylib /usr/local/etc/primesense
    $ sudo niReg -u /usr/local/lib/libXnDeviceFile.dylib /usr/local/etc/primesense
    $ sudo niReg -u /usr/local/lib/libXnVFeatures_1_5_2.dylib /usr/etc/primesense/Features_1_5_2
    $ sudo niReg -u /usr/local/lib/libXnVHandGenerator_1_5_2.dylib /usr/etc/primesense/Hands_1_5_2

Uninstall OpenNI, Sensor (or SensorKinect), and NITE with Homebrew.

	$ brew uninstall nite
    $ brew uninstall sensor (or $ brew uninstall sensor-kinect)
    $ brew uninstall openni

If you want to clean entirely,

    $ sudo rm -rf /var/lib/ni /var/log/primesense/XnSensorServer /usr/local/etc/primesense

## License

TODO