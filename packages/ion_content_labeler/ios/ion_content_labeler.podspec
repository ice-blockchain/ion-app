#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint ion_content_labeler.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'ion_content_labeler'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  # This will ensure the source files in Classes/ are included in the native
  # builds of apps using this FFI plugin. Podspec does not support relative
  # paths, so Classes contains a forwarder C file that relatively imports
  # `../src/*` so that the C sources can be shared among all target platforms.
  s.source           = { :path => '.' }
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  s.vendored_frameworks = 'Frameworks/fasttext_predict.xcframework'
  s.preserve_paths = 'Frameworks/*.xcframework/**/*'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '$(inherited) -framework fasttext_predict',
    'FRAMEWORK_SEARCH_PATHS' => '"${PODS_XCFRAMEWORKS_BUILD_DIR}/fasttext_predict"',
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }

  s.swift_version = '5.0'

  # s.resource_bundles = {
  #   'fasttext_predict' => ['Frameworks/fasttext_predict.xcframework']
  # }

  # s.script_phases = [
  #   {
  #     :name => 'Embed FastText Framework',
  #     :script => 'mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" && cp -R "${PODS_ROOT}/fasttext_predict.xcframework" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"',
  #     :execution_position => :after_compile
  #   }
  # ]
end
