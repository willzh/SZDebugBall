#
# Be sure to run `pod lib lint SZDebugBall.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SZDebugBall'
  s.version          = '1.0.9'
  s.summary          = 'App 开发，测试帮助。'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  1. App 内环境切换.
  2. 查看 App 本地文件(beta)
  3. 查看页面层级(beta)
  4. 查看 UserDefaults(beta)
  5. 查看 KeyChain (暂无)
                       DESC

  s.homepage         = 'https://github.com/willzh/SZDebugBall'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'willzh' => 'zworrks@163.com' }
  s.source           = { :git => 'https://github.com/willzh/SZDebugBall.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'SZDebugBall/Classes/**/*'
  
  # s.resource_bundles = {
  #   'SZDebugBall' => ['SZDebugBall/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
