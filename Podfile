platform :ios, '10.0'

target 'Ffalo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Ffalo

	pod "RealmSwift"
	pod "IQKeyboardManagerSwift"
	pod "KRProgressHUD"


		post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
      end
    end
end



end
