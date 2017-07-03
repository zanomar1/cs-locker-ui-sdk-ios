# Using LockerUI

_Make sure that you have [configured](./configuration.md) the locker correctly, before using it._

Please see the documented [public API of the Locker UI](../LockerUI/LockerUIApi.swift) for available functionality.

Check out the [demo application](https://github.com/Ceskasporitelna/csas-sdk-demo-ios) for usage demonstration.

## Before You Begin

Before using CoreSDK in your application, you need to initialize it by providing it your WebApiKey.

```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        CoreSDK.sharedInstance
            .useWebApiKey("YourApiKey")
            .useEnvironment(Environment.Sandbox)
        //Now you are ready to obtain the LockerUI
        let locker = LockerUI.sharedInstance.locker
        return true
    }
```

## Starting Auth Flow

To start the authentication flow, execute following command on main thread:

```swift
LockerUI.sharedInstance.startAuthenticationFlow(options: nil, completion: {status in})
```

Where options specifies `AuthFlowOptions` object used for customization of registration and unlock flow and completion block is called after either (un)successful auth or cancelation of the flow.

### Auth Flow Options

To customize behavior of LockerUI auth flow, you need to create a new instance of `AuthFlowOptions` with desired settings:

```swift
let authFlowOptions = AuthFlowOptions( skipStatusScreen: .always,
                                     registrationScreenText: "This text is displayed on registration screen",
                                           lockedScreenText: "This text is displayed on locked screen" )
```

You may pass this instance to the `startAuthenticationFlow(options:completion:)` call.

## Locking the Locker

To lock the Locker, call

```swift
CoreSDK.sharedInstance.locker.lockUser()
```

## Presenting Info Screen

To display controller with information about user registration, execute following command on main thread:

```swift
LockerUI.sharedInstance.displayInfo(options: nil, completion: {status in})
```

Where options specifies `DisplayInfoOptions` object used for customization of info controller and completion block is called after deletion of registration or cancelation of the flow.

### Info Screen Options

To customize behavior of LockerUI auth flow, you need to create a new instance of `DisplayInfoOptions` with desired settings:

```swift
let infoOptions = DisplayInfoOptions(unregisterPromptText: "Do you really want to cancel your registration? Application settings will be erased and to use the application futher you need to re-register.")
```

You may pass this instance to the `displayInfo(options:completion:)` call.

## Tracking Locker Status

To track changes of Locker status, you can subscribe to Notification Center notification using:

```swift
NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleLockerNotifications:", name: Locker.UserStateChangedNotification, object: nil)
```

To get current locker status, you can extract it from shared locker object:

```swift
let status = CoreSDK.sharedInstance.locker.status
```

## Customizing the LockerUI

To customize the visuals of LockerUI, you need to create a new instance of `LockerUIOptions` and set desired properties of the object. Afterwards, you declare to use these options:

```swift
var options = LockerUIOptions()
    options.appName = "My Awesome App"
    options.allowedLockTypes = [LockInfo(lockType: LockType.PinLock ), LockInfo(lockType: LockType.GestureLock), LockInfo(lockType: LockType.FingerprintLock), LockInfo(lockType: LockType.NoLock)]
    options.backgroundImage = UIImage(named: "myAwesomeBackground")
    options.customTint = UIColor.magentaColor()
    options.navBarColor = .default
    options.navBarTintColor = .default
    LockerUI.sharedInstance.useLockerUIOptions(options)
```

Amongst the things you can customize are:

- App name that should be displayed in the screens
- Allowed lock types
- Background image
- Custom color tint
- Custom or predefined color and tint of the navbar
- Whether to show CSAS logo or not

## Supporting landscape on iPhone

If you app supports landscape on iPhone, you have to implement the following code in the AppDelegate:

```swift
func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if LockerUI.sharedInstance.isLockerUIVisible{
            return LockerUI.sharedInstance.supportedInterfaceOrientations
        }
        return UIInterfaceOrientationMask.All
    }
```

This is due to bug in how the iOS decides about allowed orientations when multiple `UIWindow` instances are present on the screen. See the following [OpenRadar issue](http://openradar.appspot.com/19592583) for more information.

## Automating user registration for testing purposes

When you run against testing environments you can use method `injectTestingJSForRegistration(javaScript: String?)` for injecting an JavaScript that can help you automate registration of the users.

This can aid your testers or allow you to run E2E automated UI tests.

**Using this functionality when running against other than production environment is prohibited. The SDK will not run the injected JavaScript if such use is detected**
