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
            "alert": "some alert",
            "badge": 2,
            "sound": "some_audio.caf",
            "category": "some category"
            ]];
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertEqual(localNotification.alertBody, "some alert")
        XCTAssertEqual(localNotification.applicationIconBadgeNumber, 2)
        XCTAssertEqual(localNotification.soundName, "some_audio.caf")
        XCTAssertEqual(localNotification.category, "some category")
    }

    func testEmptyRemotePayload() {
        let remotePayload: [String: AnyObject] = [:]
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertNil(localNotification.alertBody)
        XCTAssertEqual(localNotification.applicationIconBadgeNumber, 0)
        XCTAssertEqual(localNotification.soundName, UILocalNotificationDefaultSoundName)
        XCTAssertNil(localNotification.category)
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

    func testSimpleDictionaryAlert() {
        let remotePayload = ["aps": [
            "alert": [
                "title": "some title",
                "body": "some body",
                "launch-image": "some_image.png"
            ]
            ]];
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertEqual(localNotification.alertTitle, "some title")
        XCTAssertEqual(localNotification.alertBody, "some body")
        XCTAssertEqual(localNotification.alertLaunchImage, "some_image.png")
    }

    func testSimpleLocalizedDictionaryAlert() {
        let remotePayload = ["aps": [
            "alert": [
                "title": "ignored title",
                "body": "ignored body",
                "title-loc-key": "localized title",
                "action-loc-key": "localized action",
                "loc-key": "localized body"
            ]
            ]];
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertEqual(localNotification.alertTitle, "localized title")
        XCTAssertEqual(localNotification.alertAction, "localized action")
        XCTAssertEqual(localNotification.alertBody, "localized body")
    }

    func testComplexLocalizedDictionaryAlert() {
        let remotePayload = ["aps": [
            "alert": [
                "title": "ignored title",
                "body": "ignored body",
                "title-loc-key": "localized %@",
                "title-loc-args": ["title"],
                "loc-key": "localized %@",
                "loc-args": ["body"]
            ]
            ]];
        let localNotification = UILocalNotification(remotePayload: remotePayload)
        XCTAssertEqual(localNotification.alertTitle, "localized title")
        XCTAssertEqual(localNotification.alertBody, "localized body")
    }
}
