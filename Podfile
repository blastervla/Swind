source 'https://github.com/CocoaPods/Specs.git'

workspace 'Swind'
project 'Swind.xcodeproj'

platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target 'SwindExamples' do
    pod 'Swind', :path => './', :inhibit_warnings => false
    
    pod 'RxSwift', '~> 5', :inhibit_warnings => true
    pod 'RxCocoa', '~> 5', :inhibit_warnings => true
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
      config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name != "MLHome"
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
        config.build_settings['IBC_WARNINGS'] = "NO"
        config.build_settings['ASSETCATALOG_WARNINGS'] = "NO"
        config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = "NO"
        config.build_settings['WARNING_CFLAGS'] ||= ['"-Wno-nullability-completeness"']
        config.build_settings['WARNING_CFLAGS'] ||= ['"-Wno-nonnull"']

        # Disable nullability completeness warning for all headers
        pod_framework_umbrella_file = File.join(installer.config.project_pods_root, "Target\ Support\ Files/#{target.name}/#{target.name}-umbrella.h")
        if File.exist?(pod_framework_umbrella_file)
            pod_framework_umbrella_content = File.read(pod_framework_umbrella_file)
            pod_framework_umbrella_content.prepend(
                <<~END
                #pragma GCC diagnostic push
                #pragma GCC diagnostic ignored \"-Wall\"\n
                #pragma GCC diagnostic ignored \"-Wextra\"\n
                #pragma GCC diagnostic ignored \"-Wmissing-declarations\"\n
                #pragma GCC diagnostic ignored \"-Wincompatible-property-type\"\n
                #pragma GCC diagnostic ignored \"-Wnullability-completeness\"\n
                #pragma GCC diagnostic ignored \"-Wdocumentation\"\n
                #pragma GCC diagnostic ignored \"-Wstrict-prototypes\"\n
                END
            )
            pod_framework_umbrella_content.concat(
                <<~END
                #pragma GCC diagnostic pop
                END
            )
            File.open(pod_framework_umbrella_file, "w") { |file| file.puts pod_framework_umbrella_content }
        end
      end
    end
  end
end
