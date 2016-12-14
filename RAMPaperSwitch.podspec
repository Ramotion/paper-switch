
Pod::Spec.new do |s|
  s.name         = 'RAMPaperSwitch'
  s.version      = '2.0.4'
  s.summary      = 'Swift subclass of the UISwitch which paints over the parent view'
  s.homepage     = 'https://github.com/Ramotion/paper-switch'
  s.license      = 'MIT'
  s.author       = { 'juri.v' => 'juri.v@ramotion.com' }
  s.source = { :git => 'https://github.com/Ramotion/paper-switch.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'PaperSwitch/*.swift'
end
