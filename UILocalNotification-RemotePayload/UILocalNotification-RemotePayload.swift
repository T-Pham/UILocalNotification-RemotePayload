//
//  UILocalNotification-RemotePayload.swift
//  UILocalNotification-RemotePayload
//
//  Created by Thanh Pham on 7/29/16.
//  Copyright © 2016 TPM. All rights reserved.
//

import UIKit

public extension UILocalNotification {

    convenience init(remotePayload: [NSString: AnyObject]?) {
        self.init()
        if let aps = remotePayload?["aps"] as? [NSString: AnyObject] {
            if let alert = aps["alert"] as? String {
                self.alertBody = alert
            }
            if let badge = aps["badge"] as? Int {
                self.applicationIconBadgeNumber = badge
            }
            if let sound = aps["sound"] as? String {
                self.soundName = sound
            }
        }
    }
}
