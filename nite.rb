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
  url 'http://www.openni.org/downloads/nite-bin-macosx-v1.5.2.21.tar.bz2'
  version 'stable-1.5.2.21'
  md5 '619d9fe68e376e650b17e52c794bdc37'

  devel do
    url 'http://www.openni.org/downloads/nite-bin-macosx-v1.5.2.21.tar.bz2'
    version 'unstable-1.5.2.21'
    md5 '619d9fe68e376e650b17e52c794bdc37'
  end

  depends_on 'openni'

  def install

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

    # niReg
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnVFeatures_1_5_2.dylib #{etc}/primesense/Features_1_5_2"
    system "#{HOMEBREW_PREFIX}/bin/niReg #{lib}/libXnVHandGenerator_1_5_2.dylib #{etc}/primesense/Hands_1_5_2"

    # niLicense
    system "#{HOMEBREW_PREFIX}/bin/niLicense PrimeSense 0KOIk2JeIBYClPWVnMoRKn5cdY4="
  end

end
