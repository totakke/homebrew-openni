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

class Nite < Formula

  homepage 'http://www.openni.org/'
  url 'http://www.openni.org/wp-content/uploads/2012/12/NITE-Bin-MacOSX-v1.5.2.21.tar.zip'
  version 'stable-1.5.2.21'
  sha1 '9dad7d093e02cf2edc50ac5e61f224eb07ba7c7e'

  depends_on 'openni'

  def install

    system 'tar zxvf NITE-Bin-MacOSX-v1.5.2.21.tar.bz2'
    cd 'NITE-Bin-Dev-MacOSX-v1.5.2.21'

    ohai 'Installing...'

    # Install libs
    lib.install Dir['Bin/libXnVNite*.dylib']
    lib.install Dir['Bin/libXnVCNITE*.dylib']
    lib.install Dir['Bin/libXnVNITE.jni*.dylib']

    # Install includes
    mkpath "#{include}/nite"
    cp_r Dir['Include/*'], "#{include}/nite"

    # Install jar
    mkpath "#{share}/java"
    cp 'Bin/com.primesense.NITE.jar', "#{share}/java"

    # Install features modules
    Dir.glob('Features*').each do |fdir|
      cd fdir
      dst_fdir = "#{etc}/primesense/" + File.basename(fdir)
      mkpath dst_fdir
      cp_r Dir['Data/*'], dst_fdir, {:remove_destination => true}
      Dir.glob('Bin/lib*.dylib').each do |dlib|
        lib.install dlib
      end
      Dir.glob('Bin/XnVSceneServer*').each do |xvss|
        chmod 0755, xvss
        bin.install xvss
      end
      cd '..'
    end

    # Install hands modules
    Dir.glob('Hands*').each do |hdir|
      cd hdir
      dst_hdir = "#{etc}/primesense/" + File.basename(hdir)
      mkpath dst_hdir
      cp_r Dir['Data/*'], dst_hdir, {:remove_destination => true}
      Dir.glob('Bin/lib*.dylib').each do |dlib|
        lib.install dlib
      end
      cd '..'
    end

    # TODO: Install .NET

    # Run make
    system 'make' if File.exist?('Makefile')

    # Install samples
    sample_dir = "#{prefix}/sample"
    mkpath sample_dir
    cp_r Dir['Samples/*'], sample_dir
    prefix.install 'Data'

    # Install docs
    doc.install Dir['Documentation']
  end

  def caveats; <<-EOS.undent
    After installation,
      Create the directory '/var/lib/ni' if it is not exist:
        $ sudo mkdir -p /var/lib/ni

      Register the following libraries manually:
        $ sudo niReg #{HOMEBREW_PREFIX}/lib/libXnVFeatures_1_5_2.dylib #{etc}/primesense/Features_1_5_2
        $ sudo niReg #{HOMEBREW_PREFIX}/lib/libXnVHandGenerator_1_5_2.dylib #{etc}/primesense/Hands_1_5_2

      Register the PrimseSense license manually:
        $ sudo niLicense PrimeSense 0KOIk2JeIBYClPWVnMoRKn5cdY4=
    EOS
  end

end
