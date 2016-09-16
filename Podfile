# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'SurpriseMe' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SurpriseMe
  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
  pod 'SwiftyJSON', :git => 'https://github.com/abarnes/SwiftyJSON.git'
  pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit.git', :tag => '0.22.0'
  pod 'Locksmith'
  pod 'RxSwift'
  pod 'RxCocoa'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |configuration|
              configuration.build_settings['SWIFT_VERSION'] = "2.3"
          end
      end
  end
  
end
