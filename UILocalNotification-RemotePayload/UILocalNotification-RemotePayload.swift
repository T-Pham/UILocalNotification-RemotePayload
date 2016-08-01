//
//  UILocalNotification-RemotePayload.swift
//  UILocalNotification-RemotePayload
//
//  Created by Thanh Pham on 7/29/16.
//  Copyright © 2016 TPM. All rights reserved.
//

import UIKit

public extension UILocalNotification {

    /**
     Creates an instance from a remote notification payload.

     - Parameter remotePayload: the remote notification payload as specified in [Apple's documentation](https://developer.apple.com/library/ios/documentation/NetworkingInternet/Conceptual/RemoteNotificationsPG/Chapters/TheNotificationPayload.html).
     */
    convenience init(remotePayload: [NSObject: AnyObject]) {
        self.init()
        self.applicationIconBadgeNumber = 0
        self.soundName = UILocalNotificationDefaultSoundName
        if let aps = remotePayload["aps"] as? [String: AnyObject] {
            if let alert = aps["alert"] {
                if let alertString = alert as? String {
                    self.alertBody = alertString
                } else if let alertDictionary = alert as? [String: AnyObject] {
                    if let titleLocKey = alertDictionary["title-loc-key"] as? String {
                        if let titleLocArgs = alertDictionary["title-loc-args"] as? [String] {
                            var convertedTitleLocArgs = [CVarArgType]()
                            for titleLocArg in titleLocArgs {
                                convertedTitleLocArgs.append(titleLocArg)
                            }
                            self.alertTitle = String(format: NSLocalizedString(titleLocKey, comment: ""), arguments: convertedTitleLocArgs)
                        } else {
                            self.alertTitle = NSLocalizedString(titleLocKey, comment: "")
                        }
                    } else if let title = alertDictionary["title"] as? String {
                        self.alertTitle = title
                    }
                    if let locKey = alertDictionary["loc-key"] as? String {
                        if let locArgs = alertDictionary["loc-args"] as? [String] {
                            var convertedLocArgs = [CVarArgType]()
                            for locArg in locArgs {
                                convertedLocArgs.append(locArg)
                            }
                            self.alertBody = String(format: NSLocalizedString(locKey, comment: ""), arguments: convertedLocArgs)
                        } else {
                            self.alertBody = NSLocalizedString(locKey, comment: "")
                        }
                    } else if let body = alertDictionary["body"] as? String {
                        self.alertBody = body
                    }
                    if let actionLocKey = alertDictionary["action-loc-key"] as? String {
                        self.alertAction = NSLocalizedString(actionLocKey, comment: "")
                    }
                    if let launchImage = alertDictionary["launch-image"] as? String {
                        self.alertLaunchImage = launchImage
                    }
                }
            }
            if let badge = aps["badge"] as? Int {
                if badge == 0 {
                    self.applicationIconBadgeNumber = -1
                } else {
                    self.applicationIconBadgeNumber = badge
                }
            }
            if let sound = aps["sound"] as? String where sound != "default" {
                self.soundName = sound
            }
            if let category = aps["category"] as? String {
                self.category = category
            }
        }
    }
}
