//
//  Authorization.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation

/**
    Функция генерации подписи для запроса.
    Документация: https://basecamp.com/2954234/projects/9473082/documents/9374715
 */
public func sign(url: String, body: String, userKey: String, secret: String, timestamp: NSTimeInterval) -> String {
    let concatenation = url + body + userKey + secret + "\(Int(timestamp))"
    var key = "d5HjIGxYEnSH5dawbOutjOjgAWhGUlXBC6iNZnpI35eNJJpkIedp8cLuHtLeOPO1".dataUsingEncoding(
        NSUTF8StringEncoding,
        allowLossyConversion: false
    )
    var data = concatenation.dataUsingEncoding(
        NSUTF8StringEncoding,
        allowLossyConversion: false
    )

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
        let hash = NSData(bytes: signatureOut, length: Int(CC_SHA256_DIGEST_LENGTH))
        let res = hash.base64EncodedDataWithOptions(.allZeros)
        return String(NSString(data: res, encoding: NSUTF8StringEncoding)!)
    }
    return "didn't work :("
}