Pod::Spec.new do |s|
  s.name             = "APIRequestObjectSwift"
  s.version          = "1.0"
  s.summary          = "Swift adapter for APIRequest"
  s.description      = <<-DESC
                       Swift adapter for APIRequest
                       DESC
  s.homepage         = "https://dev.runsystem.vn/commons-ios/apirequest"
  s.license          = 'Private'
  s.author           = { "Phạm Quang Dương" => "duongpq@runsystem.net" }
  s.source           = { :git => "git@dev.runsystem.vn:commons-ios/apirequest.git", :branch => "version/" + s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'SwiftAdapter/*.swift'
  s.dependency 'APIRequestObject'
end
