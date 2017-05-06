# CSLockerUI

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# Features

- [x] **User interface for [Locker](https://github.com/Ceskasporitelna/cs-core-sdk-ios/blob/master/docs/locker.md)** - Provide your users with secure & simple authentication interface
- [x] **Various LockTypes** - User access token can be sceured by Gesture, PIN, Fingerprint or nothing at all.
- [x] **Customizable UI flow** - Skippable status screens
- [x] **Customizable texts, colors and background** - Set various elements in the UI.

# [CHANGELOG](CHANGELOG.md)

# Requirements

- iOS 8.1+
- Xcode 8.3+

# LockerUI Installation

## Install through Carthage

If you use [Carthage](https://github.com/Carthage/Carthage) you can add a dependency on CSLockerUI by adding it to your Cartfile:

```
github 'Ceskasporitelna/cs-locker-ui-sdk-ios'
```

## Install through CocoaPods

You can install CSLockerUI by adding the following line into your Podfile:

```ruby
#Add Ceska sporitelna pods specs respository
source 'https://github.com/Ceskasporitelna/cocoa-pods-specs.git'
source 'https://github.com/CocoaPods/Specs.git'

# Include mandatory CSCoreSDK
pod 'CSCoreSDK'
pod 'CSLockerUI'
```

# Usage

After you've installed the SDK using Carthage or CocoaPods You can simply import the module wherever you wish to use it:

```swift
import CSLockerUI
```

## Configuration

**See [configuration guide](./docs/configuration.md)** on how to configure LockerUI.

## Usage

**See [Usage Guide](./docs/lockerui.md)** for usage instructions.

**TIP!** - You can also learn LockerUI by example in our [**demo**](https://github.com/Ceskasporitelna/csas-sdk-demo-ios)!

# Contributing

Contributions are more than welcome!

Please read our [contribution guide](CONTRIBUTING.md) to learn how to contribute to this project.

# Terms and License

Please read our [terms & conditions in license](LICENSE.md)
