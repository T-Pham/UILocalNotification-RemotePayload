```
'   _     _  _     ____  ____  ____  _     _      ____  _____  _  _____ _  ____  ____  _____  _  ____  _     
'  / \ /\/ \/ \   /  _ \/   _\/  _ \/ \   / \  /|/  _ \/__ __\/ \/    // \/   _\/  _ \/__ __\/ \/  _ \/ \  /|
'  | | ||| || |   | / \||  /  | / \|| |   | |\ ||| / \|  / \  | ||  __\| ||  /  | / \|  / \  | || / \|| |\ ||
'  | \_/|| || |_/\| \_/||  \_ | |-||| |_/\| | \||| \_/|  | |  | || |   | ||  \_ | |-||  | |  | || \_/|| | \||
'  \____/\_/\____/\____/\____/\_/ \|\____/\_/  \|\____/  \_/  \_/\_/   \_/\____/\_/ \|  \_/  \_/\____/\_/  \|
'                                                                                                            
'   ____  _____ _      ____  _____  _____ ____  ____ ___  _ _     ____  ____  ____                           
'  /  __\/  __// \__/|/  _ \/__ __\/  __//  __\/  _ \\  \/// \   /  _ \/  _ \/  _ \                          
'  |  \/||  \  | |\/||| / \|  / \  |  \  |  \/|| / \| \  / | |   | / \|| / \|| | \|                          
'  |    /|  /_ | |  ||| \_/|  | |  |  /_ |  __/| |-|| / /  | |_/\| \_/|| |-||| |_/|                          
'  \_/\_\\____\\_/  \|\____/  \_/  \____\\_/   \_/ \|/_/   \____/\____/\_/ \|\____/                          
'                                                                                                            
```

# UILocalNotification-RemotePayload

[![CI Status](https://img.shields.io/travis/T-Pham/UILocalNotification-RemotePayload/master.svg?style=flat-square)](https://travis-ci.org/T-Pham/UILocalNotification-RemotePayload)
[![GitHub issues](https://img.shields.io/github/issues/T-Pham/UILocalNotification-RemotePayload.svg?style=flat-square)](https://github.com/T-Pham/UILocalNotification-RemotePayload/issues)
[![Codecov](https://img.shields.io/codecov/c/github/T-Pham/UILocalNotification-RemotePayload.svg?style=flat-square)](https://codecov.io/gh/T-Pham/UILocalNotification-RemotePayload)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/UILocalNotification-RemotePayload.svg?style=flat-square)](http://cocoadocs.org/docsets/UILocalNotification-RemotePayload)

[![GitHub release](https://img.shields.io/github/tag/T-Pham/UILocalNotification-RemotePayload.svg?style=flat-square&label=release)](https://github.com/T-Pham/UILocalNotification-RemotePayload/releases)
[![Platform](https://img.shields.io/cocoapods/p/UILocalNotification-RemotePayload.svg?style=flat-square)](https://github.com/T-Pham/UILocalNotification-RemotePayload)
[![License](https://img.shields.io/cocoapods/l/UILocalNotification-RemotePayload.svg?style=flat-square)](LICENSE)

[![Carthage](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat-square)](https://github.com/Carthage/Carthage)

[![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-4BC51D.svg?style=flat-square)](https://cocoapods.org/pods/UILocalNotification-RemotePayload)
[![CocoaPods downloads](https://img.shields.io/cocoapods/dt/UILocalNotification-RemotePayload.svg?style=flat-square)](https://cocoapods.org/pods/UILocalNotification-RemotePayload)

## Description

The extension provides a convenient init method to create UILocalNotification instance from remote payload specified in [Apple's Documentation](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/TheNotificationPayload.html).

It is motivated by the fact that we have more control over local notifications than remote notifications. With local notifications, we can have notifications with behaviours as seen in apps such as [Gmail](https://itunes.apple.com/sg/app/gmail-email-from-google/id422689480?mt=8) or Facebook [Messenger](https://itunes.apple.com/sg/app/messenger/id454638411?mt=8). The Gmail app can clear the notifications of read emails on your iOS device automatically when you have read the emails on a browser. The Messenger app's notification for incoming calls can vibrate and play sound repeatedly without flooding your screen with multiple notifications. Google and Facebook might not use the same technique being discussed here, but we can have notifications with those advanced behaviours for our own apps using the technique explained below.

The idea is, instead of pushing a remote notification and having iOS displayed it to user, we push a silent notification which will invoke our app in the background, then the background code constructs a local notification from the payload and display it to user. Since we hold the local notification instance, we can remove it from the screen whenever we want. The technique only works when Background App Refresh is enabled on user's device and your app have registered background execution. However, if your app is a VoIP app using `PushKit`, the technique works even when Background App Refresh is disabled.

## Set-up

- Enable background mode in your app's `Info.plist` file:

<details open>
<summary>Non-VoIP app:</summary>

```plist
<key>UIBackgroundModes</key>
<array>
	<string>remote-notification</string>
</array>
```

</details>

<details open>
<summary>VoIP app:</summary>

```plist
<key>UIBackgroundModes</key>
<array>
	<string>voip</string>
</array>
```

</details>

- Register for local notification permission:

```swift
UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))
```
- Register for remote notification:

<details open>
<summary>Non-VoIP app:</summary>

```swift
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
	if notificationSettings.types != .None {
		application.registerForRemoteNotifications()
	}
}

func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
	// pass the deviceToken to the server
}
```

</details>

<details open>
<summary>VoIP app:</summary>

```swift
func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
	if notificationSettings.types != .None {
		let pushRegistry = PKPushRegistry(queue: dispatch_get_main_queue())
		pushRegistry.delegate = self
		pushRegistry.desiredPushTypes = [PKPushTypeVoIP]
	}
}
```

```swift
extension AppDelegate: PKPushRegistryDelegate {

	func pushRegistry(registry: PKPushRegistry!, didUpdatePushCredentials credentials: PKPushCredentials!, forType type: String!) {
		// pass credentials.token to the server
	}
}
```

</details>

- Push a notification from the server. You may want to assign it an `id`, so you can add the logic to update notifications based on their `id`.

<details open>
<summary>Non-VoIP app:</summary>

Push a silent remote notification. Put the payload to an object other than the top-level `aps` so that the notification remains silent. Here we put it in the `payload` object.

```json
{
	"aps" : {
		"content-available": 1
	},
	"payload" : {
		"aps" : {
			"alert" : "hello world"
		},
		"id" : 1
	}
}
```

</details>

<details open>
<summary>VoIP app:</summary>

Just push a normal payload because VoIP notifications are always silent.

```json
{
	"aps" : {
		"alert" : "hello world"
	},
	"id" : 1
}
```

</details>

- Handle the remote notification:

<details open>
<summary>Non-VoIP app:</summary>

```swift
func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
	let localNotification = UILocalNotification(remotePayload: userInfo["payload"] as? [NSObject: AnyObject] ?? [:])
	if let id = userInfo["payload"]?["id"] as? Int {
		if let previousLocalNotification = self.localNotificationsMap[id] {
			UIApplication.sharedApplication().cancelLocalNotification(previousLocalNotification)
		}
		self.localNotificationsMap[id] = localNotification
	}
	UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
	completionHandler(.NoData)
}
```

</details>

<details open>
<summary>VoIP app:</summary>

```swift
func pushRegistry(registry: PKPushRegistry!, didReceiveIncomingPushWithPayload payload: PKPushPayload!, forType type: String!) {
	let localNotification = UILocalNotification(remotePayload: payload.dictionaryPayload)
	if let id = payload.dictionaryPayload["id"] as? Int {
		if let previousLocalNotification = self.localNotificationsMap[id] {
			UIApplication.sharedApplication().cancelLocalNotification(previousLocalNotification)
		}
		self.localNotificationsMap[id] = localNotification
	}
	UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
}
```

</details>

## Usage

<details open>
<summary>Swift:</summary>

```swift
let localNotification = UILocalNotification(remotePayload: remotePayload)
```

</details>

<details>
<summary>Objective-C:</summary>

```objective-c
UILocalNotification *localNotification = [[UILocalNotification alloc] initWithRemotePayload:remotePayload];
```

</details>

## Installation

### [Carthage](https://github.com/Carthage/Carthage)

Add the line below to your Cartfile:

```ruby
github "T-Pham/UILocalNotification-RemotePayload"
```

### [CocoaPods](https://cocoapods.org/pods/UILocalNotification-RemotePayload)

Add the line below to your Podfile:

```ruby
pod 'UILocalNotification-RemotePayload'
```

### Manually

Add the file [`/UILocalNotification-RemotePayload/UILocalNotification-RemotePayload.swift`](/UILocalNotification-RemotePayload/UILocalNotification-RemotePayload.swift) to your project. You are all set.

## License

UILocalNotification-RemotePayload is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
