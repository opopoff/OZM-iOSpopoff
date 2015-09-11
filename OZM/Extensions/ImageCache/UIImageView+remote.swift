//
//  UIImageView+remote.swift
//  OZM
//
//  Created by Semyon Novikov on 07/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class WebImageView: AnimatableImageView {

    var req: Request? = nil

    /**
    Метод для отмены текущего реквеста
    */
    func cancelReq() -> Void {
        if let req = req {
            req.cancel()
        }
    }

    /**
    Метод для удобной загрузки картинок из сети
    */
    func setImageFromUrl(url: String, placeholder: String? = nil) -> Promise<NSData> {
        if let placeholder = placeholder {
            self.image = UIImage(named: placeholder)
        }
        return Promise { fulfill, reject in
            self.req = request(.GET, url)
            self.req!.response { _, _, data, error in
                if let error = error {
                    reject(error)
                    return
                }
                if let data = data {
                    if let image = UIImage(data: data) {
                        self.image = image
                        fulfill(data)
                    } else {
                        reject(NSError(domain: "com.ozm", code: -1, userInfo: ["description": "not an image"]))
                    }
                }
            }
        }
    }
}