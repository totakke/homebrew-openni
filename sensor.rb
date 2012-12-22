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

class Sensor < Formula

  homepage 'http://www.openni.org/'
  url 'https://github.com/PrimeSense/Sensor/tarball/Stable-5.1.0.41'
  version 'stable-5.1.0.41'
  md5 'bed5b928d9299ee5580d12213f13ba41'

  head 'https://github.com/PrimeSense/Sensor.git'

  devel do
    url 'https://github.com/PrimeSense/Sensor/tarball/Unstable-5.1.2.1'
    version 'unstable-5.1.2.1'
    md5 '7ab7582399bbab68b4e6e00871abef5d'
  end

  depends_on 'openni'

  def install

    # Fix build files
    inreplace 'Source/Utils/XnSensorServer/SensorServer.cpp', "/var/log/primesense/XnSensorServer/", "#{var}/log/primesense/XnSensorServer/"
    inreplace 'Platform/Linux/Build/EngineLibMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/Build/Utils/EngineUtilMakefile', '/usr/include/ni', "#{HOMEBREW_PREFIX}/include/ni"
    inreplace 'Platform/Linux/CreateRedist/RedistMaker', 'echo $((N_CORES*2))', 'echo $((2))'
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build Sensor
    cd 'Platform/Linux/CreateRedist'
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    redist_dir = Dir.glob('../Redist/Sensor-Bin-MacOSX-v*')[0]
    cd redist_dir

    # Install bins
    bin.install Dir['Bin/*']

    # Install libs
    lib.install Dir['Lib/*']

    # Copy config file
    mkpath "#{etc}/primesense"
    cp 'Config/GlobalDefaults.ini', "#{etc}/primesense"

    # niReg
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceSensorV2.dylib #{etc}/primesense"
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnDeviceFile.dylib #{etc}/primesense"

    # Create log directory
    mkpath "#{var}/log/primesense/XnSensorServer"
    chmod 0777, "#{var}/log/primesense/XnSensorServer"
  end

end
