# Uncomment the next line to define a global platform for your project
#platform :ios, '9.0'

target 'UniversalRremote' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for UniversalRremote
  pod 'HandyJSON', '~> 5.0.1'
  pod 'SDWebImage', '~> 5.14.1'
  pod 'SVGKit', '~> 3.0.0',:inhibit_warnings => true
  pod 'RxSwift', '6.7.1'
  pod 'RxCocoa', '6.7.1'
  pod 'Alamofire', '~> 5.9.1'
  pod 'lottie-ios', '~> 3.0.7'
  pod 'BlueSocket', '1.0.52'
  pod 'WebOSClient'
  pod "ConnectSDK"
  
  target 'UniversalRremoteTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UniversalRremoteUITests' do
    # Pods for testing
  end
    
  def __apply_Xcode_14_3_RC_post_install_workaround(installer)
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        current_target = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']  = '13.0'
        # minimum_target = 13.0 
        # if current_target.to_f < minimum_target.to_f
        #   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = minimum_target
        # end
      end
    end
  end

end
