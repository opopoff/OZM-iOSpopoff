//
//  UIImageView+remote.swift
//  OZM
//
//  Created by Semyon Novikov on 07/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import Alamofire
import Haneke

class WebImageView: AnimatableImageView {

    func clean() -> Void {
        self.hide()
    }

    func show() -> Void {
        self.setAnimating(true)
        UIView.animateWithDuration(0.2) {
            self.alpha = 1.0
        }
    }

    func hide() -> Void {
        self.setAnimating(false)
        self.alpha = 0.0
    }

    func setAnimating(animate: Bool) -> Void {
        if !animate {
            self.stopAnimatingGIF()
        } else {
            self.startAnimatingGIF()
        }
    }

    /**
    Метод для удобной загрузки картинок из сети
    */
    func setImageFromUrl(url: String, placeholder: String? = nil) -> Promise<NSData> {

        /** Увеличиваем timout для всех запросов, иначе особо жирная гифота не пролезает */
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;
        
        return Promise { fulfill, reject in
            let setImage: (NSData -> Void) = { data in
                self.animateWithImageData(data)
                self.show()
                fulfill(data)
            }

            Shared.dataCache.fetch(URL: NSURL(string: url)!)
                .onSuccess { data in
                    setImage(data)
                    fulfill(data)
                }
                .onFailure { error in
                    let err = error ?? NSError(
                        domain: "",
                        code: -1,
                        userInfo: ["description": "Cache failed without error!"]
                    )
                    reject(err)
                }
        }
    }
}