//
//  APIClient.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import PromiseKit
import JSONHelper

public struct APIClient {

    /**
    Получение фида картинок по категории
    
    - parameter category:: категория, для которой получить фид
    */
    public static func getFeed(category: Category) -> Promise<[Image]> {
        return Promise { fulfill, reject in
            let req = signedRequest(
                .GET,
                URLString: APIConstants.feed(category.id ?? -1)
            )
            req.validate().responseJSON { resp in
                if let error = resp.result.error {
                    reject(error)
                    return
                }
                if let json = resp.result.value as? [JSONDictionary] {
                    let images = json.map { Image(data: $0) }
                    fulfill(images)
                }
            }
        }
    }

    /**
    Получение списка полайканного
    */
    public static func getLiked() -> Promise<[Image]> {
        return Promise { fulfill, reject in
            let req = signedRequest(
                .GET,
                URLString: APIConstants.liked
            )
            req.validate().responseJSON { resp in
                if let error = resp.result.error {
                    reject(error)
                    return
                }
                if let json = resp.result.value as? [JSONDictionary] {
                    let images = json.map { Image(data: $0) }
                    fulfill(images)
                }
            }
        }
    }


    public static func likeImage(image: Image) -> Promise<()> {
        return Promise { fulfill, reject in
            let imageAction = ImageActionData(image: image)
            var actions = Actions()
            actions.likes = [imageAction]
            let data = try! NSJSONSerialization.dataWithJSONObject(actions.toJson(), options: .PrettyPrinted)
            print(NSString(data: data, encoding: NSUTF8StringEncoding))
            let req = signedUpload(
                .POST,
                URLString: APIConstants.userActions,
                data: data
            )
            req.validate().responseJSON { resp in
                if let error = resp.result.error {
                    reject(error)
                    return
                }
                fulfill(())
            }
        }
    }

    /**
    Получение списка категорий
    */
    public static func getCategories() -> Promise<[Category]> {
        return Promise { fulfill, reject in
            let req = signedRequest(.GET, URLString: APIConstants.categories)
            req.validate().responseJSON { resp in
                if let error = resp.result.error {
                    reject(error)
                }
                if let
                    json = resp.result.value as? JSONDictionary,
                    categories = Categories(data: json).categories {
                        print(json)
                        fulfill(categories)
                }
            }
        }
    }

    /**
    Регистрация устройства и получение секретов
    
    - parameter deviceId:: id устройства полученный при регистрации в APNS
    */
    public static func registerDevice(deviceId: String) -> Promise<RegistrationResult> {
        if let result = RegistrationResult.fromKeychain() {
            return Promise { fulfill, _ in
                fulfill(result)
            }
        }
        return Promise { fulfill, reject in
            let postData = ["deviceId": deviceId].jsonData()
            let req = signedUpload(
                .POST,
                URLString: APIConstants.registration,
                data: postData!,
                useDefaultSecrets: true
            )
            req.validate().responseJSON { resp in
                if let error = resp.result.error {
                    reject(error)
                    return
                }
                if let json = resp.result.value as? JSONDictionary {
                    let result = RegistrationResult(data: json)
                    if result.save() {
                        fulfill(result)
                    }
                }
            }
        }
    }
}
