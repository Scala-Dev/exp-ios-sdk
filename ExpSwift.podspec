#
# Be sure to run `pod lib lint ExpSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ExpSwift"
  s.version          = "1.0.1"
  s.summary          = "Exp IOS SDK library. Native IOS library for EXP platform."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "Exp IOS SDK library. Native IOS library for EXP platform will allow you to communicate directly to EXP platform."

  s.homepage         = "https://github.com/ScalaInc/exp-ios-sdk"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Cesar Oyarzun" => "cesar.oyarzun@scala.com" }
  s.source           = { :git => "https://github.com/ScalaInc/exp-ios-sdk.git", :tag => 'v1.0.1' }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'ExpSwift' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
   s.dependency 'PromiseKit','3.0.0'
   s.dependency 'Alamofire','3.1.5'
   s.dependency 'Socket.IO-Client-Swift','4.1.2'
   s.dependency 'JSONWebToken','1.4.1'
end
