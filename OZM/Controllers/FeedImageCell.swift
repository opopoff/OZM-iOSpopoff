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

    func populateWith(image: Image) -> Void {
        feedImage.setImageFromUrl(image.url!)
        self.imageView?.sizeToFit()
    }
}