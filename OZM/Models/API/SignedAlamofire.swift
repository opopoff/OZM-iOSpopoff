//
//  SignedAlamofire.swift
//  OZM
//
//  Created by Semyon Novikov on 30/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

/**
Возвращает значение заголовка Authorization для запроса на url с телом при 
помощи ранее полученных секретов пользователя
либо при помощи дефолтных секретов

*useDefaultSecrets должен использоваться только для регистрации нового девайса!*

:param: url: URL запроса
:param: data: тело запроса (может быть nil)
:param: useDefaultSecrets: если true, то для подписания будут использованы "дефолтные секреты".
*/
private func sign(url: String, body: NSData?, useDefaultSecrets: Bool = false) -> String? {
    let registration = useDefaultSecrets ? DefaultSecrets : RegistrationResult.fromKeychain()
    if let userKey = registration?.userKey, secret = registration?.secretKey {
        return sign(url, body, userKey, secret)
    }
    return nil
}

/**
Возвращает значение заголовка Authorization для запроса на url с телом при помощи указанных секретов

:param: url: URL запроса
:param: data: тело запроса (может быть nil)
:param: userKey: ключик пользователя
:param: secretKey: секретный ключик для HMAC-SHA256
*/
private func sign(url: String, data: NSData?, userKey: String, secretKey: String) -> String? {
    let timestamp = NSDate().timeIntervalSince1970
    var requestBody = data ?? "".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
    if let
        url = NSURL(string: url)?.path,
        body = NSString(data: requestBody, encoding: NSUTF8StringEncoding) as? String,
        signature = signatureFor(
            /** Сервис проверяет URL с финальным слэшем, иначе он считает, что его пытаются
            обмануть. Так как метод path возвращает относительный URL без слэша на конце,
            мы его тут добавим руками, сорян. */
            url + "/",
            body,
            userKey,
            secretKey,
            timestamp
        ) {
            return "\(userKey) \(Int(timestamp)) \(signature)"
    }
    return nil
}

/**
Создаёт подписанный Alamofire.Request с телом
*/
public func signedUpload(
    method: Method,
    URLString: URLStringConvertible,
    headers: [String: String]? = nil,
    #data: NSData,
    useDefaultSecrets: Bool = false) -> Request {
        var hdrs = headers ?? APIConstants.defaultHeaders
        hdrs["Authorization"] = sign(URLString.URLString, data, useDefaultSecrets: useDefaultSecrets) ?? ""
        return upload(method, URLString, headers: hdrs, data: data)
}

/**
Создаёт подписанный Alamofire.Request без тела
*/
public func signedRequest(
    method: Method,
    URLString: URLStringConvertible,
    parameters: [String: AnyObject]? = nil,
    encoding: ParameterEncoding = .URL,
    headers: [String: String]? = nil,
    useDefaultSecrets: Bool = false) -> Request {
        var hdrs = headers ?? APIConstants.defaultHeaders
        hdrs["Authorization"] = sign(URLString.URLString, nil, useDefaultSecrets: useDefaultSecrets) ?? ""
        return request(method, URLString, parameters: parameters, encoding: encoding, headers: hdrs)
}
