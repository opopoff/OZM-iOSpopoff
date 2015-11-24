//
//  FeedImageCell.swift
//  OZM
//
//  Created by Semyon Novikov on 09/11/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class FeedImageCell: UITableViewCell {
    
    @IBOutlet weak var feedImage: WebImageView!
    @IBOutlet weak var shareButton: UIButton!

    var delegate: ShareDelegate?
    var imageModel: Image?

    func populateWith(image: Image) -> Void {
        self.imageModel = image
        feedImage.setImageFromUrl(self.imageModel!.url!)
        //self.imageView?.sizeToFit()
    }

    @IBAction func share(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.shareImage(self.imageModel!)
        }
    }

    override func prepareForReuse() {
        self.imageModel = nil
        self.feedImage.clean()
    }
}