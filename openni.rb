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

  homepage 'https://github.com/totakke/openni-formula'
  url 'https://github.com/OpenNI/OpenNI/tarball/Stable-1.5.2.23'
  version '1.5.2.23'
  md5 '12389c56bf3685a741f6bcfa068585ff'

  @@redist_dir_name = 'OpenNI-Bin-Dev-MacOSX-v1.5.2.23'

  devel do
    url 'https://github.com/OpenNI/OpenNI/tarball/Unstable-1.5.2.23'
    version '1.5.2.23-unstable'
    md5 '0a74f9f5a8ac9af1318347ca8dbdc50d'

    @@redist_dir_name = 'OpenNI-Bin-Dev-MacOSX-v1.5.2.23'
  end

  depends_on 'libusb-freenect'
  depends_on 'libtool'
  depends_on 'automake'
  depends_on 'doxygen'

  def install

    cd 'Platform/Linux/CreateRedist'

    # Build OpenNI
    chmod 0755, 'RedistMaker'
    system './RedistMaker'

    cd '../Redist/' + @@redist_dir_name

    # Install bins
    bin.install Dir['Bin/ni*']

    # Install libs
    lib.install Dir['Lib/*']

    # Install includes
    include.install Dir['Include/*']

=begin
    # NOTE: Need to create /var/lib/ni direcotry for registering modules.
    #       A user need to register them manually after installing.
    var.mkpath
    if !File.exist?("#{var}/lib") then
      mkdir "#{var}/lib"
    end
    ni_dir = "#{var}/lib/ni"
    if !File.exist?(ni_dir) then
      mkdir ni_dir
    end
    system "export DYLD_LIBRARY_PATH=#{lib}:$DYLD_LIBRARY_PATH"
    system "Bin/niReg -r #{lib}/libnimMockNodes.dylib " + ni_dir
    system "Bin/niReg -r #{lib}/libnimCodecs.dylib " + ni_dir
    system "Bin/niReg -r #{lib}/libnimRecorder.dylib " + ni_dir
=end

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

    # Manual setup instruction
    ohai 'Please setup manually:'
    if !File.exist?('/var/lib/ni') then
      ohai '  $ sudo mkdir -p /var/lib/ni'
    end
    ohai '  $ sudo niReg /usr/local/lib/libnimMockNodes.dylib'
    ohai '  $ sudo niReg /usr/local/lib/libnimCodecs.dylib'
    ohai '  $ sudo niReg /usr/local/lib/libnimRecorder.dylib'
    
  end

end
