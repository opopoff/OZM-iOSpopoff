//
//  ViewController.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let imageView = AnimatableImageView(frame: CGRect(x: 0, y: 0, width: 500, height: 500))
        self.view.addSubview(imageView)
        
        imageView.setImageFromUrl("https://media.giphy.com/media/lXiRKeGZeOyEpRHkk/giphy.gif")
            .then { image in
                imageView.animateWithImageData(data: image)
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

