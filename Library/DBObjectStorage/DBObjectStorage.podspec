#
# Be sure to run `pod lib lint DBObjectStorage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DBObjectStorage"
  s.version          = "1.1"
  s.summary          = "Store Objects in SQLite database."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
    Store Objects in SQLite database.
                       DESC

  s.homepage         = "https://dev.runsystem.vn/commons-ios/dbobjectstorage"
  s.license          = 'Private'
  s.author           = { "Phạm Quang Dương" => "duongpq@runsystem.net" }
  s.source           = { :git => "", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
#   s.resource_bundles = {
#     'DBObjectStorage' => ['Pod/Assets/*.png']
#   }

  s.public_header_files = 'Pod/Classes/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ObjCRuntimeWrapper', '~> 1.9'
  s.dependency 'RSUtils'
  s.dependency 'CommonLog'
  s.dependency 'FMDB'
end
