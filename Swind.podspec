#
#  Be sure to run `pod spec lint Swind.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "Swind"
  spec.version      = "0.1.0"
  spec.summary      = "Databinding for Swift iOS projects, made simple"
  
  spec.description  = <<-DESC
  Swind aims to provide a simple, yet effective databinding solution for iOS
  projects. Take your MVVM development to the next level with Swind!
                   DESC

  spec.homepage     = "https://github.com/blastervla/Swind.git"

  spec.license      = { :type => "Creative Commons Attribution 4.0", :file => "LICENSE" }

  spec.author             = { "Vladimir Pomsztein" => "blastervla@gmail.com" }
  # spec.social_media_url   = "https://twitter.com/Vladimir Pomsztein"

  spec.platform     = :ios

  spec.source       = { :git => "https://github.com/blastervla/Swind.git", :tag => "#{spec.version}" }

  spec.source_files  = "Classes", "Classes/**/*.{h,m}"
  spec.exclude_files = "Classes/Exclude"

  spec.subspec 'Core' do |ss|
    ss.source_files = "Swind/Core/Classes/**/*.{h,m,swift}"
    ss.resources    = "Swind/Core/Classes/**/*.xib", "Swind/Core/Assets/**/*.xcassets"
  end

  spec.subspec 'Reactive' do |ss|
    ss.source_files = "Swind/Reactive/Classes/**/*.{h,m,swift}"
    ss.resources    = "Swind/Reactive/Classes/**/*.xib", "Swind/Core/Assets/**/*.xcassets"

    ss.dependency 'RxSwift', '~> 5'
    ss.dependency 'RxCocoa', '~> 5'
  end

end
