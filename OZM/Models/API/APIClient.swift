//
//  APIClient.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

public struct APIClient {

    public static func getCategories() -> Promise<[Category]> {
        return Promise { fulfill, reject in
            let req = signedRequest(.GET, APIConstants.categories)
            req.validate().responseJSON { _, _, js, error in
                if let error = error {
                    reject(error)
                }
                if let
                    json = js as? JSONDictionary,
                    categories = Categories(data: json).categories {
                        fulfill(categories)
                }
            }
        }
    }

    public static func registerDevice(deviceId: String) -> Promise<RegistrationResult> {
        return Promise { fulfill, reject in
            let postData = ["deviceId": deviceId].jsonData()
            let req = signedUpload(
                .POST,
                APIConstants.registration,
                data: postData!,
                useDefaultSecrets: true
            )
            req.validate().responseJSON { _, _, js, error in
                if let error = error {
                    reject(error)
                    return
                }
                if let json = js as? JSONDictionary {
                    let result = RegistrationResult(data: json)
                    if result.save() {
                        fulfill(result)
                    }
                }
            }
        }
    }
}
