# Configuration

In order to use the LockerUI, you have to configure the CoreSDK and Locker first

## 1\. Configure CoreSDK

Before you use any of the CSAS SDKs in your application, you need to initialize it by providing your WebApiKey into the CoreSDK.

```swift
CoreSDK.sharedInstance.useWebApiKey( "YourApiKey" )
```

Best place to configure the framework is in the **AppDelegate** in `application(application:, didFinishLaunchingWithOptions:)` method.

For more configuration options see **[CoreSDK configuration guide](https://github.com/Ceskasporitelna/cs-core-sdk-ios/blob/master/docs/configuration.md)**

## 2\. Configure Locker

You have to configure locker before using LockerUI.

You can find example of Locker configuration below:

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CoreSDK.sharedInstance
            .useWebApiKey("YourApiKey")
            .useEnvironment(Environment.Sandbox)
            .useLocker(
                clientId: "YourClientID",
                clientSecret: "YourClientSecret",
                publicKey: "YourPublicKey",
                redirectUrlPath: "yourscheme://your-path",
                scope: "/v1/netbanking")

        return true
    }
```

For more configuration options see **[Locker guide](https://github.com/Ceskasporitelna/cs-core-sdk-ios/blob/master/docs/locker.md)**

Please note that if you are using environment with invalid certificate and the default auth flow, there is known problem on iOS8 devices and the registration page will not load. It works fine in iOS9\. You should never be using invalid certificates in production environments! For more information see: **[discusion](https://devforums.apple.com/message/1064578#1064578)**

## 3\. Customize LockerUI

You can customize locker by using the `LockerUI.sharedInstance.useLockerUIOptions(options)` method by passing `LockerUIOptions` struct in it.

### Available customizations

- `appName` - Name of the application that should be displayed on the Locker screens
- `allowedLockTypes` - Array of LockTypes that are allowed to be used by the user
- `backgroundImage` - Background image that should be used instead of the default one.
- `customTint` - Color by which the UI should be tinted

### Lock types

There are several lock types that could be used to secure user access token:

- `PinLock` - User is verified by pin. Developer can set exact length that is required. It has to be between 4 and 8 digits long.
- `FingerprintLock` - User is verified by his/her fingerprint. This option is automatically disabled for devices that do not support fingerprint verification.
- `GestureLock` - User is verified by gesture on a grid. The length of the gesture can be set by developer. The minimal length of the gesture must be at least 4 points long.
- `NoLock` - User is not verified when the access token is retrieved from the server

Now you are all set to use the LockerUI! See the [LockerUI usage guide](lockerui.md) to learn how to use LockerUI.

## 4\. Auth Flow

### Hide cancel button

We support hidding of cancel button in authorization flow so that the user cannot cancel it. `hideCancelButtonInAuthFlow` has to be set to `true` in `AuthFlowOptions` when starting the auth flow. Please note that user can still cancel the flow in the registration screen when using the SafariViewController.
