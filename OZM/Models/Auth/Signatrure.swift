//
//  Authorization.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

/**
    Общий с сервером ключик для HMAC SHA256
 */
let sharedKey = "d5HjIGxYEnSH5dawbOutjOjgAWhGUlXBC6iNZnpI35eNJJpkIedp8cLuHtLeOPO1"

/**
    Функция генерации подписи для запроса.
    Документация: https://basecamp.com/2954234/projects/9473082/documents/9374715

    Я дальше немного попишу, чтобы не сойти с ума, когда придётся это менять.
    
    :param: url URL запроса
    :param: body Тело запроса
    :param: userKey "Публичный" ключ пользователя полученный при регистрации
    :param: secret "Секретный" ключ пользователя
    :param: timestamp Текущее время в Unixtime
 */
public func signatureFor(url: String, body: String, userKey: String, secret: String, timestamp: NSTimeInterval) -> String? {
    /** Строка, которую будем подписывать */
    let concatenation = url + body + userKey + secret + "\(Int(timestamp))"
    var key = sharedKey.dataUsingEncoding(
        NSUTF8StringEncoding,
        allowLossyConversion: false
    )
    var data = concatenation.dataUsingEncoding(
        NSUTF8StringEncoding,
        allowLossyConversion: false
    )
    /** Переменная, в которую будем складывать */
    var signatureOut = [CUnsignedChar](count: Int(CC_SHA256_DIGEST_LENGTH), repeatedValue: 0)
    if let key = key, let data = data {
        CCHmac(
            CCHmacAlgorithm(kCCHmacAlgSHA256),
            key.bytes,
            key.length,
            data.bytes, 
            data.length,
            &signatureOut
        )
        let hashData = NSData(
            bytes: signatureOut,
            length: Int(CC_SHA256_DIGEST_LENGTH)
        ).base64EncodedDataWithOptions(.allZeros)

        if let hash = NSString(data: hashData, encoding: NSUTF8StringEncoding) {
            return String(hash)
        }
        return nil
    }
    return nil
}

