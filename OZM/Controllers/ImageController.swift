//
//  ImageController.swift
//  OZM
//
//  Created by Semyon Novikov on 18/10/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import UIKit
import VKSdkFramework
import Crashlytics

class ImageController: UIViewController, UIDocumentInteractionControllerDelegate, VKSdkUIDelegate, VKSdkDelegate {

    let image: Image
    @IBOutlet weak var imageView: WebImageView!

    var documentController: UIDocumentInteractionController!

    //MARK: - Initialization
    
    init(image: Image) {
        self.image = image
        print(image.url)
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
        self.documentController.presentOptionsMenuFromRect(CGRect(), inView: self.view, animated: true)
    }

    @IBAction func vkShare(sender: AnyObject) {
        let sdkInstance = VKSdk.initializeWithAppId(VK_APP_ID)
        sdkInstance.registerDelegate(self)
        sdkInstance.uiDelegate = self
        VKSdk.wakeUpSession([VK_PER_MESSAGES], completeBlock: { state, error in
            print("Implement me, maybe")
            if state != VKAuthorizationState.Authorized {
                VKSdk.authorize([VK_PER_MESSAGES])
            }
        })
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBarHidden = true
    }

    // MARK: - VK stuff
    func vkSdkAccessAuthorizationFinishedWithResult(result: VKAuthorizationResult!) {
        print("VK Result: \(result)")
    }

    func vkSdkTokenHasExpired(expiredToken: VKAccessToken!) {
        print("Expired token: \(expiredToken)")
    }

    func vkSdkUserAuthorizationFailed() {
        print("VK Auth failed")
    }

    func vkSdkAccessTokenUpdated(newToken: VKAccessToken!, oldToken: VKAccessToken!) {
        print("VK token updated: \(newToken)")
    }

    func vkSdkDidDismissViewController(controller: UIViewController!) {
    }

    func vkSdkNeedCaptchaEnter(captchaError: VKError!) {
    }

    func vkSdkShouldPresentViewController(controller: UIViewController!) {
        self.presentViewController(controller, animated: true, completion: nil)
    }

    func vkSdkWillDismissViewController(controller: UIViewController!) {
        
    }

    // MARK: - Document interaction stuff

    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }

    func documentInteractionController(controller: UIDocumentInteractionController, willBeginSendingToApplication application: String?) {
        print("Will begin to sending")
    }

    func documentInteractionController(controller: UIDocumentInteractionController, didEndSendingToApplication application: String?) {
        print("Did end sending")
    }

    func documentInteractionController(controller: UIDocumentInteractionController, canPerformAction action: Selector) -> Bool {
        return true
    }
}