#
# Be sure to run `pod lib lint Swind.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Swind'
  s.version          = '0.6.0'
  s.summary          = 'Databinding for Swift iOS projects, made simple.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Swind aims to provide a simple, yet effective databinding solution for iOS
  projects. Take your MVVM development to the next level with Swind!
                       DESC

  s.homepage         = 'https://github.com/blastervla/Swind.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.author           = { 'Vladimir Pomsztein' => 'blastervla@gmail.com' }
  s.source           = { :git => 'https://github.com/blastervla/Swind.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.license      = { :type => "Creative Commons Attribution 4.0", :file => "LICENSE" }

  s.ios.deployment_target = '10.0'
  s.requires_arc = true
  s.static_framework = true
  s.swift_version = '5.0'
  
  s.subspec 'Core' do |ss|
    ss.source_files = "Swind/Core/Classes/**/*.{h,m,swift}"
    # ss.resources    = "Swind/Core/Classes/**/*.xib", "Swind/Core/Assets/**/*.xcassets"
  end

  s.subspec 'Reactive' do |ss|
    ss.source_files = "Swind/Reactive/Classes/**/*.{h,m,swift}"
    # ss.resources    = "Swind/Reactive/Classes/**/*.xib", "Swind/Reactive/Assets/**/*.xcassets"

    ss.dependency 'Swind/Core'
    ss.dependency 'RxSwift', '~> 5'
    ss.dependency 'RxCocoa', '~> 5'
  end

  s.subspec 'Checkbox' do |ss|
    ss.source_files = "Swind/Checkbox/Classes/**/*.{h,m,swift}"
    # ss.resources    = "Swind/Checkbox/Classes/**/*.xib", "Swind/Checkbox/Assets/**/*.xcassets"

    ss.dependency 'Swind/Core'
    ss.dependency 'M13Checkbox'
  end

  s.subspec 'Material' do |ss|
    ss.source_files = "Swind/Material/Classes/**/*.{h,m,swift}"
    # ss.resources    = "Swind/Material/Classes/**/*.xib", "Swind/Material/Assets/**/*.xcassets"

    ss.dependency 'Swind/Core'
    ss.dependency 'MaterialComponents'
  end

end
