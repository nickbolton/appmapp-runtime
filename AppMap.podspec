Pod::Spec.new do |s|
  s.name      = 'AppMap'
  s.version   = '0.0.1'
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.summary   = 'AppMap.'
  s.homepage  = 'https://github.com/nickbolton/appmapp-runtime'
  s.requires_arc = true 
  s.author    = { 'nickbolton' => 'nick@deucent.com' }             
  s.source    = { :git => 'https://github.com/nickbolton/appmapp-runtime.git',
                  :branch => 'master'}
  s.license = 'MIT'
  s.ios.source_files  = 'src/shared/**/*.{h,m}, src/ios/**/*.{h,m}'
  s.osx.source_files  = 'src/shared/**/*.{h,m}, src/osx/**/*.{h,m}'
end
