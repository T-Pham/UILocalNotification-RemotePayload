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
        if let aps = remotePayload?["aps"] as? [NSString: AnyObject], alert = aps["alert"] as? String {
            self.alertBody = alert
        }
    }
}
