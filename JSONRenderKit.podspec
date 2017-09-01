Pod::Spec.new do |s|
  s.name = 'JSONRenderKit'
  s.version = '1.1'
  s.summary = 'a library help build UI'
  s.homepage = 'https://github.com/cx478815108/JSONRenderKit'
  s.description = 'a library help build UI'

  s.license =  { :type => 'MIT' }
  s.author = { 'cx478815108' => 'feelings0811@wutnews.net' }
  s.source = { :git => 'https://github.com/cx478815108/JSONRenderKit.git', :tag => "v1.1" }
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.frameworks = "JavaScriptCore", "UIKit"
  s.dependency "SDWebImage"
  s.dependency "AFNetworking"
  s.default_subspec = 'Core'
  s.subspec 'Core' do |ss|
    ss.ios.source_files = ['Core/Category/**/*','Core/NativeSupport/**/*']
    ss.resources = "Core/JavaScript/*.js"
  end


end
