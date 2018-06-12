#
# Be sure to run `pod lib lint CMPopup.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SWUtils"
  s.version          = "2.2.1"
  s.summary          = "Util functions for Swift"

  s.description      = <<-DESC
Util functions for Swift
                       DESC

  s.homepage         = "https://dev.runsystem.vn/commons-ios/swutils"
  s.license          = 'Private'
  s.author           = { "Phạm Quang Dương" => "duongpq@runsystem.net" }
  s.source           = { :git => "git@dev.runsystem.vn:commons-ios/swutils.git", :branch => 'version/' + s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.0' }

  s.source_files = 'SWUtils/*.swift'
  # s.resource_bundles = {
  #   'CMPopup' => ['Pod/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'CommonLog', '~> 1.2.9'
end
