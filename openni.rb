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

class Openni < Formula

  homepage 'http://www.openni.org/'
  url 'https://github.com/OpenNI/OpenNI/tarball/Stable-1.5.2.23'
  version 'stable-1.5.2.23'
  sha1 'df8998be4e20664f11c7894bca0a2697815ef4b4'

  head 'https://github.com/OpenNI/OpenNI.git'

  devel do
    url 'https://github.com/OpenNI/OpenNI/tarball/Unstable-1.5.4.0'
    version 'unstable-1.5.4.0'
    sha1 '73bcfd47af26d615247db2f0e632e651d33834f'
  end

  depends_on :automake
  depends_on :libtool
  depends_on 'libusb'
  depends_on 'doxygen'

  def install

    cd 'Platform/Linux/CreateRedist'

    # Build OpenNI
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    redist_dir = Dir.glob('../Redist/OpenNI-Bin-Dev-MacOSX-v*')[0]
    cd redist_dir

    # Install bins
    bin.install Dir['Bin/ni*']

    # Install libs
    lib.install Dir['Lib/*']

    # Install includes
    mkpath "#{include}/ni"
    cp_r Dir['Include/*'], "#{include}/ni"

    # Install jar files
    jar_dir = "#{share}/java"
    mkpath jar_dir
    cp_r Dir['Jar/*'], jar_dir

    # Install samples
    sample_dir = "#{prefix}/sample"
    mkpath sample_dir
    cp_r Dir['Samples/*'], sample_dir

    # Install docs
    doc.install Dir['Documentation']
  end

  def caveats; <<-EOS.undent
    Require libusb with option '--universal'.
    If you have not installed it or failed to install OpenNI, install it by the following command:
      $ brew install libusb --universal

    After installation,
      Create the directory '/var/lib/ni' if it is not exist:
        $ sudo mkdir -p /var/lib/ni

      Register the following libraries manually:
        $ sudo niReg #{HOMEBREW_PREFIX}/lib/libnimMockNodes.dylib
        $ sudo niReg #{HOMEBREW_PREFIX}/lib/libnimCodecs.dylib
        $ sudo niReg #{HOMEBREW_PREFIX}/lib/libnimRecorder.dylib
    EOS
  end

end
