Pod::Spec.new do |s|
  s.name                   = 'HCImage+BPG'
  s.version                = '1.2.1'
  s.source                 = { :git => 'https://github.com/hoppenichu/HCImage-BPG.git', :tag => s.version }

  s.summary                = 'BPG decoder for iOS and OS X'
  s.homepage               = 'https://github.com/hoppenichu/HCImage-BPG'
  s.license                = { :type => 'MIT', :file => 'LICENSE' }
  s.author                 = { 'Takeru Chuganji' => 'takeru@hoppenichu.com' }

  s.ios.deployment_target  = '8.0'
  s.osx.deployment_target  = '10.10'
  s.requires_arc           = true
  s.source_files           = 'ImageBPG/*.{h,mm}', 'ImageBPG/Internal/*.{hpp,cpp}', 'ImageBPG/Internal/libbpg/include/*.h'
  s.osx.vendored_libraries = 'ImageBPG/Internal/libbpg/lib/mac/*.a'
  s.ios.vendored_libraries = 'ImageBPG/Internal/libbpg/lib/ios/*.a'
  s.private_header_files   = 'ImageBPG/Internal/*.hpp'
  s.library                = 'c++'
end
