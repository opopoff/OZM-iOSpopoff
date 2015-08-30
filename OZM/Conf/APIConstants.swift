//
//  APIConstants.swift
//  OZM
//
//  Created by Semyon Novikov on 27/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

public let DefaultSecrets = RegistrationResult(
    userKey: "mtFxlt3JsW4D5wOl",
    secretKey: "mu4C3KOi5zhqeMz7xAzkYT0lmrAeXy8JhMtEpd9ln6O7T8dN1aEm4lEY7xLtWqid"
)

public struct APIConstants {

    /** Headers */
    static let defaultHeaders = ["Content-Type": "application/json"]

    /* Handles */
    static let baseUrl = "http://debug.ozm.rocks:49124"
    static let registration = "/api/register/"
    static let categories = "/api/categories/"
}