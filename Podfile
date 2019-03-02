
inhibit_all_warnings!
use_frameworks!

platform :ios, '11.0'
workspace 'TiketReactions.xcworkspace'

def shared_with_all_pods
  pod 'Kickstarter-Prelude'
  pod 'ReactiveSwift', '~> 3.0'
  pod 'Result'
  pod 'SwiftGen'
end

target 'TiketReactions' do
  project 'TiketReactions.xcodeproj'

  shared_with_all_pods
  pod 'Argo'
  pod 'AloeStackView'
  pod 'CalendarDateRangePickerViewController'
  pod 'Curry'
  pod 'Runes'
  pod 'Alamofire', '~> 4.6'
  pod 'AlamofireImage'
  pod 'FSPagerView'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'KINWebBrowser'
  pod 'PDFReader'
  pod 'PhoneNumberKit'
  pod 'RealmSwift'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git'
  pod 'SwiftSoup'

  target 'TiketReactionsTests' do
    # Pods for testing
    pod 'FBSnapshotTestCase'
  end

  target 'TiketReactionsUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'TiketKitModels' do
  project 'TiketKitModels/TiketKitModels.xcodeproj'

  shared_with_all_pods
  pod 'Argo'
  pod 'Curry'
  pod 'Runes'
  pod 'PhoneNumberKit'

  target 'TiketKitModelsTests' do
     pod 'FBSnapshotTestCase'
  end


end

