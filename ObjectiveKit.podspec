#
# Be sure to run `pod lib lint PhoneNumberKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ObjectiveKit"
  s.version          = "0.2.0"
  s.summary          = "Swift friendly API for a set of Objective C runtime functions."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
                        ObjectiveKit provides a Swift friendly API for a set of powerful Objective C runtime functions.
                       DESC

  s.homepage         = "https://github.com/marmelroy/ObjectiveKit"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Roy Marmelstein" => "marmelroy@gmail.com" }
  s.source           = { :git => "https://github.com/marmelroy/ObjectiveKit.git", :tag => s.version.to_s }
  s.social_media_url   = "http://twitter.com/marmelroy"

  s.ios.deployment_target = '8.0'
  s.requires_arc = true

  s.source_files = "ObjectiveKit"

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
