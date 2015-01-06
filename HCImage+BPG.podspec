Pod::Spec.new do |s|
  s.name                  = "HCImage+BPG"
  s.version               = "1.0"
  s.source                = { :git => "https://github.com/hoppenichu/HCImage-BPG.git", :tag => s.version }

  s.summary               = "BPG decoder for iOS and OS X"
  s.homepage              = "https://github.com/hoppenichu/HCImage-BPG"
  s.license               = { :type => "MIT", :file => "LICENSE" }
  s.author                = { "Takeru Chuganji" => "takeru@hoppenichu.com" }

  s.ios.deployment_target = "7.0"
  s.osx.deployment_target = "10.9"
  s.requires_arc          = true
  s.source_files          = "HCImage+BPG/*.{h,m}"

  s.default_subspec       = "libbpg"

  s.subspec "libbpg" do |ss|
    ss.source_files       = "HCImage+BPG/libbpg/include/*.h"
    ss.vendored_libraries = "HCImage+BPG/libbpg/lib/*.a"
    ss.header_dir         = "libbpg"
  end
end
