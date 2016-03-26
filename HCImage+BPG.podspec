Pod::Spec.new do |s|
  s.name                   = 'HCImage+BPG'
  s.version                = '1.3.1'
  s.source                 = { :git => 'https://github.com/hoppenichu/HCImage-BPG.git', :tag => s.version }

  s.summary                = 'BPG decoder for iOS and OS X'
  s.homepage               = 'https://github.com/hoppenichu/HCImage-BPG'
  s.license                = { :type => 'MIT', :file => 'LICENSE' }
  s.author                 = { 'Takeru Chuganji' => 'takeru@hoppenichu.com' }

  s.ios.deployment_target  = '8.0'
  s.osx.deployment_target  = '10.10'
  s.requires_arc           = true
  s.source_files           = 'HCImage+BPG/*.{h,mm}', 'HCImage+BPG/Internal/**/*.{h,hpp,cpp}'
  s.private_header_files   = 'HCImage+BPG/Internal/**/*.{h,hpp}'
  s.osx.vendored_libraries = 'HCImage+BPG/Internal/libbpg/lib/mac/*.a'
  s.osx.framework          = 'Cocoa', 'CoreGraphics'
  s.ios.vendored_libraries = 'HCImage+BPG/Internal/libbpg/lib/ios/*.a'
  s.ios.framework          = 'UIKit', 'CoreGraphics'
  s.library                = 'c++'
end
