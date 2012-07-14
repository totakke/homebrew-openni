#
#   openni-formula
#   https://github.com/totakke/openni-formula
#   Copyright (C) 2012, Toshiki TAKEUCHI.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'formula'

class SensorKinect < Formula

  homepage 'https://github.com/avin2/SensorKinect/'
  url 'https://github.com/avin2/SensorKinect/tarball/v0.91-5.1.0.25'
  version 'stable-5.1.0.25'
  md5 '57ed1f44e9c67761bf167ba998cafbec'

  head 'https://github.com/avin2/SensorKinect.git'

  devel do
    url 'https://github.com/avin2/SensorKinect/tarball/v0.93-5.1.2.1'
    version 'unstable-5.1.2.1'
    md5 '533b2a65c46077fa8f1768f6a8e2f223'
  end

  depends_on 'openni'

  def install
    cd 'Platform/Linux/CreateRedist'

    # Fix RedistMaker
    inreplace 'RedistMaker', 'echo $((N_CORES*2))', 'echo $((N_CORES))'

    # Build SnesorKinect
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    cd Dir.glob('../Redist/Sensor-Bin-MacOSX-v*')[0]

    # Install bins
    bin.install Dir['Bin/*']

    # Install libs
    lib.install Dir['Lib/*']

    # Copy config file
    if !File.exist?("#{etc}/primesense") then
      mkpath "#{etc}/primesense"
    end
    cp 'Config/GlobalDefaultsKinect.ini', "#{etc}/primesense"
  end

  def caveats; <<-EOS.undent
      After installation,
        Create the directory '/var/lib/ni' if not exist:
          $ sudo mkdir -p /var/lib/ni

        Register the following libraries manually:
          $ sudo niReg #{HOMEBREW_PREFIX}/lib/libXnDeviceSensorV2KM.dylib #{etc}/primesense
          $ sudo niReg #{HOMEBREW_PREFIX}/lib/libXnDeviceFile.dylib #{etc}/primesense

        Create the log directory '/var/log/primesense/XnSensorServer' if not exist:
          $ sudo mkdir -p /var/log/primesense/XnSensorServer
          $ sudo chmod a+w /var/log/primesense/XnSensorServer
    EOS
  end

end
