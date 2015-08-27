//
//  RegistrationTests.swift
//  OZM
//
//  Created by Semyon Novikov on 27/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import XCTest
import OZM


class RegistrationTestst: XCTestCase {

    func testRegistration() {
        let expectation = expectationWithDescription("Регистрация должна чем-то кончиться")
        var registrationResponse: RegistrationResult? = nil

        let gotResult: (RegistrationResult? -> Void) = { (result: RegistrationResult?) in
            registrationResponse = result
            expectation.fulfill()
        }

        APIClient.registerDevice("testid")
            .then { response in
                gotResult(response)
            }
            .catch { error in
                XCTFail("Ошибка регистрации: \(error.userInfo)")
                expectation.fulfill()
            }

        waitForExpectationsWithTimeout(10.0) { error in
            if let error = error {
                print("Error: \(error)")
            }
            println(registrationResponse)
        }
    }
}