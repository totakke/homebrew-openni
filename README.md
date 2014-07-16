# homebrew-openni

homebrew-openni is a project for installing [OpenNI][openni] related modules with [Homebrew][homebrew]: Sensor, SensorKinect, and NITE.

You can install these packages in Homebrew installing directory (default: /usr/local) by simple commands.
Uninstalling is also easy.
This project does not provide only [Sensor][sensor] module (sensor.rb) for Xtion and Xtion PRO LIVE but also [SensorKinect][sensor-kinect] module (sensor-kinect.rb) for Microsoft Kinect sensor.
You can choose a proper module for your device.

If you want to use OpenNI2, refer to [homebrew-openni2][homebrew-openni2].

## NOTICE

OpenNI formula is now provided by [homebrew-science][homebrew-science], so homebrew-openni won't provide it.
homebrew-openni is supporting Sensor, SensorKinect, and NITE formulas.

## Version info

* Sensor
    * v5.1.6.6
* SensorKinect
    * v0.94
* NITE
    * v1.5.2.21

## Usage

### Download formulas

First, tap homebrew-science and homebrew-openni.

    $ brew tap homebrew/science
    $ brew tap totakke/openni

### Install

Install OpenNI, Sensor/SensorKinect, and NITE with Homebrew.

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

    $ cd `brew --cellar openni`/1.5.7.10/share/openni/sample/Bin/x64-Release
    $ ./Sample-NiSimpleViewer

### Uninstall

Uninstall OpenNI, Sensor (or SensorKinect), and NITE with Homebrew.

    $ brew uninstall nite
    $ brew uninstall sensor (or $ brew uninstall sensor-kinect)
    $ brew uninstall openni

If you want to clean entirely,

    $ cd `brew --prefix`
    $ rm -rf var/lib/ni var/log/primesense/XnSensorServer etc/primesense

## License

Code is under the [BSD 2 Clause (NetBSD) license][license].

[openni]:http://openni.org/
[homebrew]:http://mxcl.github.com/homebrew/
[homebrew-science]:https://github.com/Homebrew/homebrew-science
[sensor]:https://github.com/PrimeSense/Sensor
[sensor-kinect]:https://github.com/ruedigerH2/SensorKinect/
[homebrew-openni2]:https://github.com/totakke/homebrew-openni2
[license]:https://github.com/totakke/homebrew-openni/blob/master/LICENSE
