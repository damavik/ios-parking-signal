source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def common_pods
  pod 'Fabric'
  pod 'Crashlytics'

  pod 'Alamofire', '~> 3.1.2'
  pod 'ObjectMapper', '~> 1.1'
  pod 'KeychainAccess', '~> 2.3'

  pod 'SnapKit', '~> 0.18' # A Swift Autolayout DSL for iOS & OS X
  pod 'UINavigationBar+Addition', '~> 1.3'
  pod 'IQKeyboardManagerSwift', '3.3.4'
  pod 'MZFormSheetPresentationController', '~> 2.2'
  pod 'MRProgress', '~> 0.7'
  pod 'SwiftHEXColors'
end

target 'Parking' do

    platform :ios, '8.0'
    common_pods
end

target 'ParkingTests' do

    platform :ios, '8.0'
    common_pods

end

target 'ParkingUITests' do

    platform :ios, '8.0'
    common_pods
    pod 'KIF', '~> 3.3'

end

# Make sure that pod frameworks built for all the possible architectures
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
