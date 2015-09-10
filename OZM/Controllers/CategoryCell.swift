//
//  CategoryCell.swift
//  OZM
//
//  Created by Semyon Novikov on 11/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var imageView: AnimatableImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func populateWith(category: Category) -> Void {
        imageView.setImageFromUrl(category.backgroundImage!).then { data in
            self.imageView.animateWithImageData(data: data)
        }
    }
}