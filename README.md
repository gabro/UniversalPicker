# UniversalPicker

[![Version](https://img.shields.io/cocoapods/v/UniversalPicker.svg?style=flat)](http://cocoapods.org/pods/UniversalPicker)
[![License](https://img.shields.io/cocoapods/l/UniversalPicker.svg?style=flat)](http://cocoapods.org/pods/UniversalPicker)
[![Platform](https://img.shields.io/cocoapods/p/UniversalPicker.svg?style=flat)](http://cocoapods.org/pods/UniversalPicker)

Let the user pick a photo, a video or a file, in the simplest way possible.

No more fiddling with the clumsy delegate-based `UIImagePickerController` API

## Example

To run the example project, run `pod try UniversalPicker`

## Usage

### Example: pick a photo

```swift
UniversalPicker.pickPhoto(inViewController: self) { photo in
  if let photo = photo {
    // do something wonderful with this photo
  } else {
    // the user cancelled
  }
}
```

This will automatically let the user choose a source (library or camera) and then present the default image picker or the camera.

Simple, as it should be.

## Requirements
`UniversalPicker` has no third party dependencies.

If you want to use the file picker, you will need to [add the iCloud Entitlements](https://developer.apple.com/library/ios/documentation/IDEs/Conceptual/AppDistributionGuide/AddingCapabilities/AddingCapabilities.html) to your app.

## Installation

UniversalPicker is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "UniversalPicker"
```

## Author

Gabriele Petronella, gabriele@buildo.io

## License

UniversalPicker is available under the MIT license. See the LICENSE file for more info.
