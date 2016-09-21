Pod::Spec.new do |s|
  s.name = 'RLMObject-Copying'
  s.version = '0.1.1'
  s.summary = 'RLMObject-Copying'
  s.homepage = 'https://github.com/yusuga/RLMObject-Copying'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/RLMObject-Copying.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/RLMObject-Copying/*.{h,m}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
  
  s.dependency 'Realm', '~> 1.0.0'
end