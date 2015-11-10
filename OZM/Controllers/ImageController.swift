//
//  ImageController.swift
//  OZM
//
//  Created by Semyon Novikov on 18/10/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class ImageController: UIViewController, UIDocumentInteractionControllerDelegate {

    let image: Image
    @IBOutlet weak var imageView: WebImageView!

    var documentController: UIDocumentInteractionController!

    //MARK: - Initialization
    
    init(image: Image) {
        self.image = image
        super.init(nibName: "ImageController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupDocumentController(image: Image, data: NSData) -> Void {
        var ext = ".jpg"
        if let isGif = image.isGIF where isGif == true {
            ext = ".gif"
        }
        let savePath = NSHomeDirectory().stringByAppendingString("/tmp\(ext)")
        data.writeToFile(savePath, atomically: true)
        documentController = UIDocumentInteractionController(URL: NSURL.fileURLWithPath(savePath))
        documentController.delegate = self
        self.fakeShare(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.setImageFromUrl(image.url!).then { data in
            self.setupDocumentController(self.image, data: data)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }

    @IBAction func fakeShare(sender: AnyObject) {
        APIClient.likeImage(self.image)
        documentController.presentOptionsMenuFromRect(CGRect(), inView: self.view, animated: true)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    // MARK: - Document interaction stuff

    func documentInteractionControllerWillPresentOpenInMenu(controller: UIDocumentInteractionController) {
        print("Trying!")
    }

    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}