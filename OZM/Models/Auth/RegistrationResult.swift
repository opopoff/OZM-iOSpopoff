//
//  RegistrationResult.swift
//  OZM
//
//  Created by Semyon Novikov on 27/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

public struct RegistrationResult: Deserializable {
    var userKey: String?
    var secretKey: String?

    public init(data: JSONDictionary) {
        self.userKey <-- data["key"]
        self.secretKey <-- data["secret"]
    }
}
