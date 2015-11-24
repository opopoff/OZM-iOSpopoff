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
import AlamofireImage

class WebImageView: AnimatableImageView {

    var req: Request? = nil

    func clean() -> Void {
        self.image = nil
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
        return Promise { fulfill, reject in
            let setImage: (NSData -> Void) = { data in
                self.animateWithImageData(data)
                self.show()
                fulfill(data)
            }

            let request = NSURLRequest(URL: NSURL(string: url)!)

            self.af_setImageWithURLRequest(
                request,
                placeholderImage: placeholder != nil ? UIImage(named: placeholder!) : nil,
                filter: nil,
                imageTransition: .None,
                completion: { response in
                    if let error = response.result.error {
                        reject(error)
                        return
                    }
                    if let data = response.data {
                        setImage(data)
                        fulfill(data)
                    } else {
                        fulfill(NSData())
                    }
                }
            )
        }
    }
}