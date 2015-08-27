//
//  APIClient.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

public struct APIClient {

    private static func sign(
        request: NSMutableURLRequest,
        userKey: String = "mtFxlt3JsW4D5wOl",
        secretKey: String = "mu4C3KOi5zhqeMz7xAzkYT0lmrAeXy8JhMtEpd9ln6O7T8dN1aEm4lEY7xLtWqid") -> NSMutableURLRequest?
    {
        let timestamp = NSDate().timeIntervalSince1970
        if let
            url = request.URL?.path,
            bodyData = request.HTTPBody,
            body = NSString(data: bodyData, encoding: NSUTF8StringEncoding) as? String,
            signature = signatureFor(
                /** 
                Сервис проверяет URL с финальным слэшем, иначе он считает, что его пытаются
                обмануть. Так как метод path возвращает относительный URL без слэша на конце,
                мы его тут добавим руками, сорян. 
                */
                url + "/",
                body,
                userKey,
                secretKey,
                timestamp
            )
        {
            let authHeader = "\(userKey) \(Int(timestamp)) \(signature)"
            request.allHTTPHeaderFields?["Authorization"] = authHeader
            return request
        }
        return nil
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
            }

            let registerUrl="/api/register/"

            var request = NSMutableURLRequest(
                URL: NSURL(string: "http://debug.ozm.rocks:49124\(registerUrl)")!,
                cachePolicy: .UseProtocolCachePolicy,
                timeoutInterval: 10.0
            )
            request.HTTPMethod = "POST"
            request.allHTTPHeaderFields = ["Content-Type": "application/json"]
            request.HTTPBody = postData
            request = sign(request)!

            let session = NSURLSession.sharedSession()
            let dataTask = session.dataTaskWithRequest(request) { data, response, error in
                 if let error = error {
                    reject(error)
                } else {
                    if let httpResponse = response as? NSHTTPURLResponse {
                        if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                            var parsingError: NSError?
                            let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(
                                data,
                                options: NSJSONReadingOptions.allZeros,
                                error: &parsingError
                            )
                            if let error = parsingError {
                                reject(error)
                            }
                            if let json = json as? JSONDictionary {
                                fulfill(RegistrationResult(data: json))
                            }
                        } else {
                            reject(
                                NSError(
                                    domain: "com.ozm.api",
                                    code: httpResponse.statusCode,
                                    userInfo: [
                                        "description": "Not 20x response code",
                                        "responseString": NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                                    ]
                                )
                            )
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
}
