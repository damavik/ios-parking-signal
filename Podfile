source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

def common_pods
  pod 'Fabric', '1.6.11'
  pod 'Crashlytics', '3.8.3'

  pod 'Alamofire', '4.2.0'
  pod 'ObjectMapper', '2.2.2'
  pod 'KeychainAccess', '3.0.1'

  pod 'SnapKit', '3.0.2' # A Swift Autolayout DSL for iOS & OS X
  pod 'UINavigationBar+Addition', '1.3.0'
  pod 'IQKeyboardManagerSwift', '4.0.7'
  pod 'MZFormSheetPresentationController', '2.4.2'
  pod 'MRProgress', '0.8.3'
  pod 'SwiftHEXColors', '1.1.0'
end

target 'Parking' do
    common_pods
end

target 'ParkingTests' do
    common_pods
end

target 'ParkingUITests' do
    common_pods
    pod 'KIF', '3.5.1'

end

# Make sure that pod frameworks built for all the possible architectures
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
