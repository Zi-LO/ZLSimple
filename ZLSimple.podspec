Pod::Spec.new do |s|
  s.name         = "ZLSimple"
  s.version      = "0.0.1"
  s.summary      = "Simple tools."
  s.homepage     = "https://github.com/Zi-LO/zl-ios"
  s.license      = { :type => 'MIT', :file => 'LICENSE'}
  s.author       = { "Zi-LO" => "jiroiwas@gmail.com" }
  s.source       = { :git => "http://github.com/Zi-LO/zl-ios.git", :tag => "0.0.1" }
  s.source_files = 'ZLSimple/**/*.{h,m}'
  s.requires_arc = true
  
  s.ios.deployment_target = '6.1'
end
