#
# Be sure to run `pod lib lint CMDefaults.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "CMDefaults"
  s.version          = "1.0.0"
  s.summary          = "Bridge to NSUserDefaults"
  s.description      = <<-DESC
                       Help log & easy using NSUserDefaults
                       DESC
  s.license          = 'Private'
  s.author           = { "Phạm Quang Dương" => "duongpq@runsystem.net" }
  s.homepage         = "https://dev.runsystem.vn/commons-ios/"
  s.source           = { :git => "git@dev.runsystem.vn:commons-ios/not_existed.git", :branch => "version/" + s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/*'
  s.dependency 'CommonLog'
  s.dependency 'ObjCRuntimeWrapper'
  s.dependency 'RSUtils'
end
