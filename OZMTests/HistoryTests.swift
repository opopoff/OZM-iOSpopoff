//
//  HistoryTests.swift
//  OZM
//
//  Created by Semyon Novikov on 22/10/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import XCTest
import JSONHelper

@testable import UMAD

class HistoryTests: XCTestCase {

    var image1: Image?
    var image2: Image?
    var history = History(storage: HistoryArchive)

    override func setUp() {
        var data: JSONDictionary = [:]
        data["id"] = 42
        data["url"] = "http://ololo"
        data["sharingUrl"] = "http://ololo.share"
        data["videoUrl"] = "http://ololo.video"
        data["thumbnailUrl"] = "http://ololo.thumb"
        data["categoryId"] = 43
        data["categoryDescription"] = "OLOLO CAT"
        data["liked"] = false
        data["shared"] = false
        data["width"] = 5
        data["height"] = 5
        data["thumbnailWidth"] = 5
        data["thumbnailHeight"] = 5
        data["isGIF"] = true
        data["isNew"] = false
        data["isNewBlink"] = true
        data["mainColor"] = "#fff"
        data["timeUsed"] = 42

        image1 = Image(data: data)

        var data2: JSONDictionary = [:]
        data2["id"] = 42
        data2["url"] = "http://ololo"
        data2["sharingUrl"] = "http://ololo.share"
        data2["videoUrl"] = "http://ololo.video"
        data2["thumbnailUrl"] = "http://ololo.thumb"
        data2["categoryId"] = 43
        data2["categoryDescription"] = "OLOLO CAT"
        data2["liked"] = false
        data2["shared"] = false
        data2["width"] = 5
        data2["height"] = 5
        data2["thumbnailWidth"] = 5
        data2["thumbnailHeight"] = 5
        data2["isGIF"] = true
        data2["isNew"] = false
        data2["isNewBlink"] = true
        data2["mainColor"] = "#fff"
        data2["timeUsed"] = 42

        image2 = Image(data: data2)

        history.add(image1!)
        history.add(image2!)
    }

    func testAdding() {
        XCTAssertEqual(history.images().count, 2)
    }

    func testOrdering() {
        XCTAssertEqual(history.images()[0].id, image2!.id, "Приехали не в том порядке")
        XCTAssertEqual(history.images()[1].id, image1!.id, "Приехали не в том порядке")
    }
}
