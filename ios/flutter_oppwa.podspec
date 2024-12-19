#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_oppwa.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_oppwa'
  s.version          = '3.10.0'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '10.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig    = { 'OTHER_LDFLAGS' => '-framework OPPWAMobile -framework ipworks3ds_sdk' }
  s.preserve_paths = 'OPPWAMobile.xcframework', 'ipworks3ds_sdk'
  s.vendored_frameworks = 'OPPWAMobile.xcframework', 'ipworks3ds_sdk.xcframework'
  s.static_framework = true
end
