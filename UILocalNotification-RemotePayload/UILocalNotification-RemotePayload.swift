//
//  UILocalNotification-RemotePayload.swift
//  UILocalNotification-RemotePayload
//
//  Created by Thanh Pham on 7/29/16.
//  Copyright © 2016 TPM. All rights reserved.
//

import UIKit

public extension UILocalNotification {

    convenience init(remotePayload: [String: AnyObject]) {
        self.init()
        self.applicationIconBadgeNumber = 0
        self.soundName = UILocalNotificationDefaultSoundName
        if let aps = remotePayload["aps"] as? [String: AnyObject] {
            if let alert = aps["alert"] {
                if let alertString = alert as? String {
                    self.alertBody = alertString
                } else if let alertDictionary = alert as? [String: AnyObject] {
                    if let title = alertDictionary["title"] as? String {
                        self.alertTitle = title
                    }
                    if let body = alertDictionary["body"] as? String {
                        self.alertBody = body
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
