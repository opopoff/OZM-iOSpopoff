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

class WebImageView: UIImageView {

    func clean() -> Void {
        self.image = nil
        self.hide()
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
    func setImageFromUrl(url: String, placeholder: String? = nil, isGIF: Bool = true) -> Promise<NSData> {

        /** Увеличиваем timout для всех запросов, иначе особо жирная гифота не пролезает */
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;

        self.image = nil

        return Promise { fulfill, reject in
            let setImage: (NSData -> Void) = { data in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), {
                    let image = UIImage.animatedGIFWithData(data)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.image = image
                        self.show()
                    })
                })
                fulfill(data)
            }

            Shared.dataCache.fetch(URL: NSURL(string: url)!)
                .onSuccess { data in
                    setImage(data)
                    fulfill(data)
                }
                .onFailure { error in
                    setImage(NSData())
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