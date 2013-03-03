# openni-formula

openni-formula is a project for installing [OpenNI](http://openni.org/), NITE, and Sensor module with [Homebrew](http://mxcl.github.com/homebrew/).

You can install these packages in Homebrew installing directory (default: /usr/local) by simple commands.
Uninstalling is also easy.
This project does not provide only [Sensor](https://github.com/PrimeSense/Sensor) module (sensor.rb) for Xtion and Xtion PRO LIVE but also [SensorKinect](https://github.com/avin2/SensorKinect) module (sensor-kinect.rb) for Microsoft Kinect sensor.
You can choose a proper module for your device.

## Versions

* OpenNI
    * stable-1.5.2.23
    * (--devel) unstable-1.5.4.0
* Sensor
    * stable-5.1.0.41
    * (--devel) unstable-5.1.2.1
* SensorKinect
    * stable-5.1.0.25
    * (--devel) unstable-5.1.2.1
* NITE
    * stable-1.5.2.21

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

    $ cd /usr/local/Cellar/openni/stable-1.5.2.23/sample/Bin/x64-Release
    $ ./Sample-NiSimpleViewer 

### Uninstall

Uninstall OpenNI, Sensor (or SensorKinect), and NITE with Homebrew.

    $ brew uninstall nite
    $ brew uninstall sensor (or $ brew uninstall sensor-kinect)
    $ brew uninstall openni

If you want to clean entirely,

    $ sudo rm -rf /usr/local/var/lib/ni /usr/local/var/log/primesense/XnSensorServer /usr/local/etc/primesense

## Note

If you fail to install OpenNI, uninstall `libusb` and install OpenNI again.

    $ brew uninstall libusb
    $ brew install openni

## License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License.

You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.