#
# Be sure to run `pod lib lint CombineDitto.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CombineDitto'
  s.version          = '0.1.4'
  s.summary          = "DittoSwift extension methods with Apple Combine framework."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This is an extension method library that adds publisher methods to DittoSwift queries. This makes it
extremely easy to integrate DittoSwift into SwiftUI apps.
DESC

  s.homepage         = 'https://github.com/getditto/CombineDitto'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors          = {
    '2183729' => 'max@ditto.live',
    'Ben Chatelain' => 'ben@ditto.live',
  }
  s.source           = { :git => 'https://github.com/getditto/CombineDitto.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dittolive'

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'
  s.source_files = 'CombineDitto/Classes/**/*'

  s.dependency 'DittoSwift', '>=1.0.9'

  # DittoSwift isn't available for all simulator types
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.deprecated_in_favor_of = 'DittoSwift'
end
