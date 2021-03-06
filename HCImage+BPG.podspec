Pod::Spec.new do |s|
  s.name                   = 'HCImage+BPG'
  s.version                = '1.4.0'
  s.source                 = { :git => 'https://github.com/chuganzy/HCImage-BPG.git', :tag => s.version }

  s.summary                = 'BPG decoder for iOS and OS X'
  s.homepage               = 'https://github.com/chuganzy/HCImage-BPG'
  s.license                = { :type => 'MIT', :file => 'LICENSE' }
  s.author                 = { 'Takeru Chuganji' => 'chu@ganzy.jp' }

  s.ios.deployment_target  = '8.0'
  s.osx.deployment_target  = '10.10'
  s.requires_arc           = true
  s.source_files           = 'HCImage+BPG/*.{h,mm}', 'HCImage+BPG/Internal/**/*.{h,hpp,cpp}'
  s.private_header_files   = 'HCImage+BPG/Internal/**/*.{h,hpp}'
  s.osx.vendored_libraries = 'HCImage+BPG/Internal/libbpg/lib/mac/*.a'
  s.ios.vendored_libraries = 'HCImage+BPG/Internal/libbpg/lib/ios/*.a'
  s.osx.framework          = 'AppKit', 'CoreGraphics'
  s.ios.framework          = 'UIKit',  'CoreGraphics'
  s.library                = 'c++'
end
