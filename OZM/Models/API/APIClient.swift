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
            let req = signedRequest(.GET, "\(APIConstants.baseUrl)\(APIConstants.categories)")
            req.validate().responseJSON { _, _, js, error in
                if let error = error {
                    reject(error)
                }
                if let
                    json = js as? JSONDictionary,
                    categories = Categories(data: json).categories {
                        fulfill(categories)
                        return
                }
            }
        }
    }

    public static func registerDevice(deviceId: String) -> Promise<RegistrationResult> {
        return Promise { fulfill, reject in
            let payload = ["deviceId": deviceId]
            var error: NSError? = nil
            let postData = NSJSONSerialization.dataWithJSONObject(
                payload,
                options: nil,
                error: &error
            )
            if let error = error {
                reject(error)
                return
            }

            let req = signedUpload(
                .POST,
                "\(APIConstants.baseUrl)\(APIConstants.registration)",
                data: postData!,
                useDefaultSecrets: true
            )

            req.validate().responseJSON { request, response, js, error in
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
