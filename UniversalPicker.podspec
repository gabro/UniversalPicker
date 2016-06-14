#
# Be sure to run `pod lib lint UniversalPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "UniversalPicker"
  s.version          = "1.0.0"
  s.summary          = "A hassle-free asset picker for photos, videos and files"

  s.description      = <<-DESC
                       A hassle-free asset picker for photos, videos and files
                       In case of photo/videos, it automatically prompts for camera/library choice
                       In case of document, allows selecting from any file provider
                       DESC

  s.homepage         = "https://github.com/gabro/UniversalPicker"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Gabriele Petronella" => "gabriele@buildo.io" }
  s.source           = { :git => "https://github.com/gabro/UniversalPicker.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/gabro27'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.frameworks = 'UIKit', 'Photos', 'MobileCoreServices'
end
