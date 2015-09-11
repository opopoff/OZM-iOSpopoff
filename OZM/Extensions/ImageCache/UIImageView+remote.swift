//
//  UIImageView+remote.swift
//  OZM
//
//  Created by Semyon Novikov on 07/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

var cache: [String: NSData] = [:]

class WebImageView: AnimatableImageView {

    var req: Request? = nil

    func clean() -> Void {
        self.cancelReq()
        self.hide()
    }

    /**
    Метод для отмены текущего реквеста
    */
    func cancelReq() -> Void {
        if let req = req {
            req.cancel()
        }
    }

    func show() -> Void {
        UIView.animateWithDuration(0.2) {
            self.alpha = 1.0
        }
    }

    func hide() -> Void {
        self.alpha = 0.0
    }

    /**
    Метод для удобной загрузки картинок из сети
    */
    func setImageFromUrl(url: String, placeholder: String? = nil) -> Promise<NSData> {
        if let placeholder = placeholder {
            self.image = UIImage(named: placeholder)
            self.show()
        }
        return Promise { fulfill, reject in
            let setImage: (NSData -> Void) = { data in
                self.animateWithImageData(data: data)
                self.show()
                fulfill(data)
            }

            if let data = cache[url] {
                setImage(data)
                return
            }
            self.req = request(.GET, url)
            self.req!.response { _, _, data, error in
                if let error = error {
                    reject(error)
                    return
                }
                if let data = data {
                    cache[url] = data
                    setImage(data)
                    fulfill(data)
                }
            }
        }
    }
}