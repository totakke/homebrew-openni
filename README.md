# homebrew-openni

homebrew-openni is a project for installing [OpenNI][openni], NITE, and Sensor module with [Homebrew][homebrew].

You can install these packages in Homebrew installing directory (default: /usr/local) by simple commands.
Uninstalling is also easy.
This project does not provide only [Sensor][sensor] module (sensor.rb) for Xtion and Xtion PRO LIVE but also [SensorKinect][sensor-kinect] module (sensor-kinect.rb) for Microsoft Kinect sensor.
You can choose a proper module for your device.

If you want to use OpenNI2, refer to [homebrew-openni2][homebrew-openni2].

## Versions

* OpenNI
    * stable-1.5.2.23
    * (--devel) unstable-1.5.4.0
* Sensor
    * stable-5.1.0.41
    * (--devel) unstable-5.1.2.1
* SensorKinect
    * 0.91-5.1.0.25
    * (--devel) 0.93-5.1.2.1
* NITE
    * 1.5.2.21

## Usage

### Download formulas

First, tap homebrew-openni.

    $ brew tap totakke/openni

### Install

Install OpenNI, Sensor/SensorKinect, and NITE with Homebrew.
If you want to install unstable release, add `--devel` option.

    Install OpenNI.
    $ brew install openni

    Install Sensor.
    $ brew install sensor

    (Or install SensorKinect instead if you want to use Microsoft Kinect sensor.)
    ($ brew install sensor-kinect)

    Install NITE.
    $ brew install nite

### Run sample for test

Connect a device to the PC and run a sample program.

    $ cd `brew --cellar openni`/stable-1.5.2.23/sample/Bin/x64-Release
    $ ./Sample-NiSimpleViewer

### Uninstall

Uninstall OpenNI, Sensor (or SensorKinect), and NITE with Homebrew.

    $ brew uninstall nite
    $ brew uninstall sensor (or $ brew uninstall sensor-kinect)
    $ brew uninstall openni

If you want to clean entirely,

    $ cd `brew --prefix`
    $ rm -rf var/lib/ni var/log/primesense/XnSensorServer etc/primesense

## Note

If you fail to install OpenNI, uninstall `libusb` and install OpenNI again.

    $ brew uninstall libusb
    $ brew install openni

## License

Code is under the [BSD 2 Clause (NetBSD) license][license].

[openni]:http://openni.org/
[homebrew]:http://mxcl.github.com/homebrew/
[sensor]:https://github.com/PrimeSense/Sensor
[sensor-kinect]:https://github.com/avin2/SensorKinect
[homebrew-openni2]:https://github.com/totakke/homebrew-openni2
[license]:https://github.com/totakke/homebrew-openni/blob/master/LICENSE
