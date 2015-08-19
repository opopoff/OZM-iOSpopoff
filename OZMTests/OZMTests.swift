//
//  OZMTests.swift
//  OZMTests
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import UIKit
import XCTest
import OZM

class HMACTest: XCTestCase {

    func testHmac() {
        let hmac = signRequest(
            "/authentication/register/",
            "{\"deviceId\":\"1235123\"}",
            "mtFxlt3JsW4D5wOl",
            "mu4C3KOi5zhqeMz7xAzkYT0lmrAeXy8JhMtEpd9ln6O7T8dN1aEm4lEY7xLtWqid",
            1433878667
        )
        XCTAssert(hmac == "cuGDC6wM+/hAx1tnBwM2q0+Vh9I3o+WKRK2Ihe1fRkg=")
    }
}
