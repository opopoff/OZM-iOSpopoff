
//
//  CategoriesTests.swift
//  OZM
//
//  Created by Semyon Novikov on 30/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import UIKit
import XCTest
import OZM

class CategoriesTests: XCTestCase {

    func testGet() {
        let expectation = expectationWithDescription("Запрос категорий")
        var catsResult: [OZM.Category]? = nil

        let gotResult: ([OZM.Category]? -> Void) = { (result: [OZM.Category]?) in
            catsResult = result
            expectation.fulfill()
        }
        APIClient.registerDevice("testid").then { resp in 
            APIClient.getCategories().then { categories in
                gotResult(categories)
            }
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