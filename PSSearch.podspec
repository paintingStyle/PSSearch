#
# Be sure to run `pod lib lint PSSearch.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#  pod trunk push PSSearch.podspec --allow-warnings --verbose

Pod::Spec.new do |s|
  s.name             = 'PSSearch'
  s.version          = '1.0.2'
  s.summary          = '联系人呢称/拼音/字母搜索组件'
  s.homepage         = 'https://github.com/paintingStyle/PSSearch'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'paintingStyle' => 'renshuangfu@spap.com' }
  s.source           = { :git => 'https://github.com/paintingStyle/PSSearch.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'PSSearch/Classes/**/*'
  s.dependency 'PinYin4Objc'
  
end

