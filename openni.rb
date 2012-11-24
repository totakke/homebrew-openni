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
  md5 '12389c56bf3685a741f6bcfa068585ff'

  head 'https://github.com/OpenNI/OpenNI.git'

  devel do
    url 'https://github.com/OpenNI/OpenNI/tarball/Unstable-1.5.4.0'
    version 'unstable-1.5.4.0'
    md5 '204594b8dc65e3c3acb86dd99ac18c56'
  end

  depends_on :automake
  depends_on :libtool
  depends_on 'libusb'
  depends_on 'doxygen'

  def install

    # Fix build files
    inreplace 'Source/OpenNI/XnOpenNI.cpp', '/var/lib/ni/', "#{var}/lib/ni/"
    inreplace 'Platform/Linux/Build/Common/CommonJavaMakefile', '/usr/share/java', "#{share}/java"

    # Build OpenNI
    cd 'Platform/Linux/CreateRedist'
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

    mkpath "#{var}/lib/ni"
    system "#{bin}/niReg #{lib}/libnimMockNodes.dylib"
    system "#{bin}/niReg #{lib}/libnimCodecs.dylib"
    system "#{bin}/niReg #{lib}/libnimRecorder.dylib"
  end

  def caveats; <<-EOS.undent
    Requires libusb with option '--universal'.
    If you have not installed it or failed to install OpenNI, install it by the following command:
      $ brew install libusb --universal
    EOS
  end

end
