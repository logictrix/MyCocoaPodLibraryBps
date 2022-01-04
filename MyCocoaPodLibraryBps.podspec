#
# Be sure to run `pod lib lint MyCocoaPodLibraryBps.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MyCocoaPodLibraryBps'
  s.version          = '0.5.0'
  s.summary          = 'This library use to scan docs of user.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/logictrix/MyCocoaPodLibraryBps'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'logictrix' => 'b.singh@logictrixtech.com' }
  s.source           = { :git => 'https://github.com/logictrix/MyCocoaPodLibraryBps.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.swift_version = '5.0'
  s.ios.deployment_target = '12.0'

  s.source_files = 'MyCocoaPodLibraryBps/Classes/**/*'
  
   s.resource_bundles = {
     
     'Resources' => ['MyCocoaPodLibraryBps/MainFACEKI.{png,storyboard,lproj,gif}','MyCocoaPodLibraryBps/Faceki-Verifing-animation2.{gif}','MyCocoaPodLibraryBps/Assets/Scan ID front side.{png,jpg}','MyCocoaPodLibraryBps/Assets/Scan ID back side.{png,jpg}','MyCocoaPodLibraryBps/Assets/Take a selfie picture.{png,jpg}','MyCocoaPodLibraryBps/Assets/verifyAnimation.{png,jpg}','MyCocoaPodLibraryBps/Assets/VerifyBlurBack.{png,jpg}' ,'MyCocoaPodLibraryBps/Assets/appstore.{png,jpg}','MyCocoaPodLibraryBps/Assets/Extra Check Required.{png,jpg}','MyCocoaPodLibraryBps/Assets/Flip Camera.{png,jpg}','MyCocoaPodLibraryBps/Assets/Successful.{png,jpg}','MyCocoaPodLibraryBps/Assets/Passport black.{png,jpg}','MyCocoaPodLibraryBps/Assets/appstore1.{png,jpg}','MyCocoaPodLibraryBps/Assets/Driving back black.{png,jpg}','MyCocoaPodLibraryBps/Assets/Driving back.{png,jpg}','MyCocoaPodLibraryBps/Assets/Driving Front black.{png,jpg}','MyCocoaPodLibraryBps/Assets/Driving Front.{png,jpg}','MyCocoaPodLibraryBps/Assets/framesArtboard 1.{png,jpg}','MyCocoaPodLibraryBps/Assets/FRONT SIDE- 2.{png,jpg}','MyCocoaPodLibraryBps/Assets/Passport.{png,jpg}','MyCocoaPodLibraryBps/Assets/Camera- Take a Selfie.{png,jpg}','MyCocoaPodLibraryBps/Assets/Splash.{png,jpg}','MyCocoaPodLibraryBps/Assets/BACK SIDE -2.{png,jpg}','MyCocoaPodLibraryBps/Assets/TaleSelfie.{png,jpg}','MyCocoaPodLibraryBps/Assets/TaleSelfie1.{png,jpg}','MyCocoaPodLibraryBps/Assets/Artboard 2 copy 8.{png,jpg}','MyCocoaPodLibraryBps/Assets/Artboard 2 copy 9.{png,jpg}','MyCocoaPodLibraryBps/24-approved-checked-outline.{gif}','MyCocoaPodLibraryBps/25-error-cross-outline.{gif}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
   s.frameworks = 'UIKit', 'AVKit', 'AVFoundation', 'Vision'
   s.dependency 'Alamofire', '~> 5.0'
   s.dependency 'MBProgressHUD'
   s.dependency 'IQKeyboardManagerSwift'
   s.dependency 'SwiftyGif'
   
   
end
