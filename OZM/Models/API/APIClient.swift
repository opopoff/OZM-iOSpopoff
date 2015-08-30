//
//  APIClient.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

public struct APIClient {

    /**
     Получение фида картинок по категории
     */
    public static func getFeed(category: Category) -> Promise<[Image]> {
        return Promise { fulfill, reject in
            let req = signedRequest(
                .GET,
                APIConstants.feed(category.id ?? -1)
            )
            req.validate().responseJSON { _, _, js, error in
                if let error = error {
                    reject(error)
                    return
                }
                if let json = js as? [JSONDictionary] {
                    let images = json.map { Image(data: $0) }
                    fulfill(images)
                }
            }
        }
    }

    /**
    Получение списка категорий
    */
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

    /**
    Регистрация устройства и получение секретов
    
    :param: deviceId: id устройства полученный при регистрации в APNS
    */
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
