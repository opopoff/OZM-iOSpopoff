//
//  FeedTests.swift
//  OZM
//
//  Created by Semyon Novikov on 30/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import UIKit
import XCTest
import UMAD

class FeedTests: XCTestCase {

    func testGetLiked() {
        let expectation = expectationWithDescription("Запрос полайканного")

        var images: [Image]? = nil

        let gotResult: ([Image]? -> Void) = { (imgs: [Image]?) in
            images = imgs
            expectation.fulfill()
        }

        APIClient.getLiked().then { images in
            gotResult(images)
        }.catch_ { error in
            XCTFail("\(error)")
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10.0) { error in
            if let error = error {
                XCTFail("Беда: \(error)")
            }
            XCTAssert(images != nil)
            for image in images! {
                XCTAssertNil(image.id)
                XCTAssertNotNil(image.url)
                XCTAssertNotNil(image.thumbnailUrl)
            }
        }
    }

//    func testLike() {
//        let expectation = expectationWithDescription("Лайк картинки")
//
//        APIClient.getCategories().then { categories in
//            APIClient.getFeed(categories.first!)
//            }.then { images in
//                APIClient.likeImage(images.first!)
//            }.then {
//                expectation.fulfill()
//            }.catch_ { error in
//                XCTFail("\(error)")
//                expectation.fulfill()
//        }
//
//        waitForExpectationsWithTimeout(10.0) { error in
//            if let error = error {
//                XCTFail("Беда: \(error)")
//            }
//        }
//
//    }

    func testGetFeed() {
        let expectation = expectationWithDescription("Запрос фида")


        var images: [Image]? = nil

        let gotResult: ([Image]? -> Void) = { (imgs: [Image]?) in
            images = imgs
            expectation.fulfill()
        }

        APIClient.getCategories().then { categories in
            APIClient.getFeed(categories.first!)
            }.then { images in
                gotResult(images)
            }.catch_ { error in
                expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10.0) { error in
            if let error = error {
                XCTFail("Беда: \(error)")
            }
            XCTAssert(images != nil)
            for image in images! {
                XCTAssertNotNil(image.id)
                XCTAssertNotNil(image.url)
                XCTAssertNotNil(image.thumbnailUrl)
            }
        }
    }
}
