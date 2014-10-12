Pod::Spec.new do |s|
  s.name      = 'AppMap Runtime'
  s.version   = '0.0.1'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.summary   = 'AppMap Runtime.'
  s.homepage  = 'https://github.com/nickbolton/appmapp-runtime'
  s.requires_arc = true 
  s.author    = { 'nickbolton' => 'nick@deucent.com' }             
  s.source    = { :git => 'https://github.com/nickbolton/appmapp-runtime.git',
                  :branch => 'master'}
  s.prefix_header_file = 'Source/AppMap.h'
  s.license = 'MIT'
  s.source_files  = 'Source/**/*.{h,m}'
end
