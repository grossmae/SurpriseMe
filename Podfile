# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'SurpriseMe' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SurpriseMe
  pod 'Alamofire', '~> 4.0'
  pod 'SwiftyJSON', '3.0.0'
  pod 'SnapKit', '~> 3.0'
  pod 'Locksmith', '~>3.0.0'
  pod 'RxSwift',    '~> 3.0.0-beta.1'
  pod 'RxCocoa',    '~> 3.0.0-beta.1'
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |configuration|
              configuration.build_settings['SWIFT_VERSION'] = "3.0"
          end
      end
  end
  
end
