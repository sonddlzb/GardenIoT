# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

def RxSwiftPod
   pod 'RxSwift'
   pod 'RxCocoa'
end

def RIBsPod
   pod 'RIBs', :git => 'https://github.com/uber/RIBs/', :tag => 'v0.10.0' 
end

target 'GardenIoT' do
  use_frameworks!

  # Pods for GardenIoT
  pod 'SwiftLint'
  pod 'TLLogging'
  pod 'Resolver'
  pod 'Alamofire'
  pod 'SVProgressHUD'
  pod 'SDWebImage'
  pod 'CocoaMQTT'
  RxSwiftPod()
  RIBsPod()

end
