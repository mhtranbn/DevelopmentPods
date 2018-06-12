#
# Be sure to run `pod lib lint APIRequestObject.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "APIRequestObject"
  s.version          = "3.0"
  s.summary          = "APIRequest base"
  s.description      = <<-DESC
                       Base class to make API request
                       DESC
  s.homepage         = "https://dev.runsystem.vn/commons-ios/apirequest"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'Private'
  s.author           = { "Phạm Quang Dương" => "duongpq@runsystem.net" }
  s.source           = { :git => "git@dev.runsystem.vn:commons-ios/apirequest.git", :branch => "version/" + s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
#  s.resource_bundles = {
#    'APIRequestObject' => ['Pod/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.private_header_files = 'Pod/Classes/APIRequest_Private.h'
  s.dependency 'ObjCRuntimeWrapper', '>= 1.9'
  s.dependency 'RSUtils'
  s.dependency 'CommonLog'
end
