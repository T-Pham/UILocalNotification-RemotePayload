//
//  UILocalNotification_RemotePayloadTests.swift
//  UILocalNotification-RemotePayloadTests
//
//  Created by Thanh Pham on 7/29/16.
//  Copyright © 2016 TPM. All rights reserved.
//

import XCTest
@testable import UILocalNotification_RemotePayload

class UILocalNotification_RemotePayloadTests: XCTestCase {

    func testSimpleRemotePayload() {
        let remotePayload = ["aps": [
            "alert": "some message",
            "badge": 2,
            "sound": "some_audio.caf",
            ]];
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssert(localNotification.alertBody == "some message")
        XCTAssert(localNotification.applicationIconBadgeNumber == 2)
        XCTAssert(localNotification.soundName == "some_audio.caf")
    }
}
