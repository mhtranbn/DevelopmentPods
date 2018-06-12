#
# Be sure to run `pod lib lint ObjCRuntimeWrapper.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ObjCRuntimeWrapper"
  s.version          = "1.10"
  s.summary          = "Wrapper for Objective C Runtime."
  s.description      = <<-DESC
                       Wrapper for Objective C Runtime.
                       DESC
  s.homepage         = "http://dev.runsystem.vn/commons-ios/objcruntimewrapper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'Private'
  s.author           = { "Phạm Quang Dương" => "duongpq@runsystem.net" }
  s.source           = { :git => "git@dev.runsystem.vn:commons-ios/objcruntimewrapper.git", :branch => 'version/' + s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
#  s.resource_bundles = {
#    'ObjCRuntimeWrapper' => ['Pod/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'RSUtils'
  s.dependency 'CommonLog'
end
