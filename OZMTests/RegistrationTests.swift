//
//  RegistrationTests.swift
//  OZM
//
//  Created by Semyon Novikov on 27/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import XCTest
import UMAD


class RegistrationTestst: XCTestCase {

    override func setUp() {
        Locksmith.clearKeychain()
    }

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
            .catch_ { error in
                XCTFail("Ошибка регистрации: \(error.userInfo)")
                expectation.fulfill()
            }

        waitForExpectationsWithTimeout(10.0) { error in
            if let error = error {
                XCTFail("Беда: \(error)")
            }
            XCTAssertNotNil(registrationResponse?.userKey, "Приехал пустой ключик")
            XCTAssertNotNil(registrationResponse?.secretKey, "Приехал пустой секрет")

            let restored = RegistrationResult.fromKeychain()
            XCTAssertNotNil(restored?.secretKey, "Похоже, результат не сохранился в Keychain")
        }
    }

    func testResultKeychainInteraction() {
        let registration = RegistrationResult(userKey: "testKey", secretKey: "secret!")
        XCTAssertTrue(registration.save(), "Не получилось сохранить регистрацию в кейчейн")

        let restored = RegistrationResult.fromKeychain()
        XCTAssert(restored != nil, "Не удалось восстановить регистрацию из кейчейна")

        if let restored = restored {
            XCTAssertEqual(restored.userKey!, registration.userKey!)
            XCTAssertEqual(restored.secretKey!, registration.secretKey!)
        }
    }
}

