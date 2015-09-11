
//
//  CategoriesTests.swift
//  OZM
//
//  Created by Semyon Novikov on 30/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import UIKit
import XCTest
import UMAD

class CategoriesTests: XCTestCase {

    func testGet() {
        let expectation = expectationWithDescription("Запрос категорий")
        var catsResult: [UMAD.Category]? = nil

        let gotResult: ([UMAD.Category]? -> Void) = { (result: [UMAD.Category]?) in
            catsResult = result
            expectation.fulfill()
        }
        APIClient.registerDevice("testid").then { _ in
            APIClient.getCategories()
        }.then { categories in
            gotResult(categories)
        }
        waitForExpectationsWithTimeout(10.0) { error in
            if let error = error {
                XCTFail("Беда: \(error)")
            }
            XCTAssert(catsResult?.count > 0)
            for category in catsResult! {
                XCTAssertNotNil(category.id)
                XCTAssertNotNil(category.description)
                XCTAssertNotNil(category.backgroundImage)
            }
        }
    }
}