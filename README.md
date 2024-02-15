# KEDeviceManager

Library to detect used device

## Install
### Carthage

To integrate KEDeviceManager using Carthage, add the following line to your `Cartfile`:


```ruby
github "KorelskayaElya/KEDeviceManager"
```

### CocoaPods

To integrate KEDeviceManager using CocoaPods, add the following lines to your `Podfile`:

```ruby
# platform :ios, '12.0'

target 'YourProjectName' do
  use_frameworks!
  
  pod 'KEDeviceManager'

end
```

Run `pod install` to install the dependency in your project.

## Usage

```swift
import KEDeviceManager

// get information about the currently used device
let deviceName = DeviceManager.sharedInstance.showUsingDevice()
print(deviceName)

// or get the model name first,
// then pass to the method getDeviceDescription and get information about the currently used device
let deviceModel = DeviceManager.sharedInstance.getModelName()
guard let deviceName = DeviceManager.sharedInstance.getDeviceDescription(key: deviceModel) else { return }
print("Device - \(deviceModel), is - \(deviceName)")
```



