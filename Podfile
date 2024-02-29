# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Sneni' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Sneni
  
  pod 'SDWebImage'
  pod 'AFNetworking', '~> 3.0', :subspecs => ['Reachability', 'Serialization', 'Security', 'NSURLSession']
  pod 'Alamofire'
  pod 'Material'
  pod 'EZSwiftExtensions'
  pod 'DropDown'
  pod 'NVActivityIndicatorView'
  pod 'MRCountryPicker'
  pod 'SwiftyJSON'
  pod 'ENSwiftSideMenu'
  pod 'YYWebImage'
  pod 'IQKeyboardManager'
  pod 'TYAlertController'
  pod 'AMRatingControl'
  pod 'SKPhotoBrowser'
  pod 'RMMapper'
  pod 'SZTextView'
  
  pod 'RMDateSelectionViewController', '~> 2.3.1'
  pod 'RCPageControl'
  pod 'ESPullToRefresh'
  pod 'GooglePlaces'
  pod 'GooglePlacePicker'
  pod 'GooglePlacesAPI'
  pod 'GoogleMaps'
  pod 'Fabric'
  pod 'CryptoSwift'
  pod 'ESPullToRefresh'
  pod 'Flurry-iOS-SDK/FlurrySDK'
 pod 'Adjust', '~> 4.29.7'
  pod 'Cosmos', '~> 16.0'
  
  pod 'Socket.IO-Client-Swift' , '~> 13.1.0'
  pod 'ObjectMapper'
  pod 'Moya'
  
  pod 'ApiAI'
  
  pod 'SkeletonView'
  pod 'Firebase/Analytics'
  pod 'Firebase/DynamicLinks'
  pod 'Firebase/Messaging'
  
  pod 'FacebookCore'
  pod 'FacebookShare'
  pod 'FacebookLogin'
  pod 'ADCountryPicker', '~> 2.1.0'
  pod 'Stripe'
  
  pod 'Braintree'
  pod 'BraintreeDropIn'
  pod 'Braintree/Apple-Pay'
  pod 'Braintree/PayPal'
  pod 'Braintree/Venmo'
  pod 'Braintree/DataCollector'
  pod 'FlagPhoneNumber'
  pod 'Lightbox'
  pod 'DBAttachmentPickerController'
  
  pod "SquareInAppPaymentsSDK"
  pod 'ZendeskSupportSDK'
  pod 'Paystack'
  
  pod 'ISMessages'
  pod 'R.swift'
  pod 'IBAnimatable'
  pod 'Permission/Camera'
  pod 'Permission/Photos'
  pod 'SwiftMessages', '~> 4.1.4'
  pod 'Kingfisher', '~> 4.1.0'
  pod 'SideMenu'
  pod 'HCSStarRatingView', '~> 1.5'
  pod 'Crashlytics'
  pod 'EPContactsPicker'
  pod 'razorpay-pod'
  
  pod 'libPhoneNumber-iOS'
  
end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
