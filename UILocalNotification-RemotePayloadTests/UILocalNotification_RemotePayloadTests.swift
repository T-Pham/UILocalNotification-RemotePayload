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
        XCTAssertEqual(localNotification.alertBody, "some message")
        XCTAssertEqual(localNotification.applicationIconBadgeNumber, 2)
        XCTAssertEqual(localNotification.soundName, "some_audio.caf")
    }

    func testEmptyPayload() {
        let remotePayload: [String: AnyObject] = [:]
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertNil(localNotification.alertBody)
        XCTAssertEqual(localNotification.applicationIconBadgeNumber, 0)
        XCTAssertEqual(localNotification.soundName, UILocalNotificationDefaultSoundName)
    }

    func testZeroBadge() {
        let remotePayload = ["aps": [
            "badge": 0
            ]];
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertLessThan(localNotification.applicationIconBadgeNumber, 0)
    }

    func testDefaultSound() {
        let remotePayload = ["aps": [
            "sound": "default"
            ]];
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertEqual(localNotification.soundName, UILocalNotificationDefaultSoundName)
    }
}
