//
//  ImageCell.swift
//  OZM
//
//  Created by Semyon Novikov on 11/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: WebImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.clean()
    }

    func populateWith(image: Image) -> Void {
        imageView.setImageFromUrl(image.url!)
    }
}