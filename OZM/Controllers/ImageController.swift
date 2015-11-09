//
//  ImageController.swift
//  OZM
//
//  Created by Semyon Novikov on 18/10/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class ImageController: UIViewController {

    let image: Image
    @IBOutlet weak var imageView: WebImageView!

    //MARK: - Initialization
    
    init(image: Image) {
        self.image = image
        super.init(nibName: "ImageController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.setImageFromUrl(image.url!)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    @IBAction func fakeShare(sender: AnyObject) {
        APIClient.likeImage(self.image)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }
}