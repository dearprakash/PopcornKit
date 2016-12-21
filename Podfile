use_frameworks!

source 'https://github.com/CocoaPods/Specs'
source 'https://github.com/angryDuck2/CocoaSpecs'

def pods
 pod 'Alamofire', '~> 4.2.0'
 pod 'ObjectMapper', '~> 2.1.0'
 pod 'AlamofireXMLRPC', '~> 2.1.0'
 pod 'SwiftyJSON', '~> 3.1.1'
 pod 'Locksmith', '~> 3.0.0'
end

target 'PopcornKit tvOS' do
    platform :tvos, '9.0'
    pods
end

target 'PopcornKit iOS' do
    platform :ios, '9.0'
    pods
    pod 'google-cast-sdk', '~> 3.3.0'
    pod 'SRT2VTT', '~> 1.0.1'
end
