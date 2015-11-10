//
//  MainViewController.swift
//  OZM
//
//  Created by Semyon Novikov on 17/10/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pages: UIView!

    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var categoriesButton: UIButton!
    @IBOutlet weak var feedButton: UIButton!

    var categoriesCtrl: CategoriesController!
    var historyCtrl: ImagesController!
    var feedController: FeedController!

    init() {
        super.init(nibName: "MainViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if self.historyCtrl != nil {
            return
        }

        self.navigationController?.navigationBarHidden = true

        self.historyCtrl = ImagesController()
        self.historyCtrl.historyMode = true
        self.historyCtrl.view.frame = CGRect(
            x: 0,
            y: 0,
            width: self.scrollView.frame.size.width,
            height: self.scrollView.frame.size.height
        )

        self.categoriesCtrl = CategoriesController()
        self.categoriesCtrl.view.frame = self.scrollView.frame
        self.categoriesCtrl.view.frame = CGRect(
            x: self.view.frame.size.width,
            y: 0,
            width: self.scrollView.frame.size.width,
            height: self.scrollView.frame.height
        )
        self.feedController = FeedController()
        self.feedController.view.frame = self.scrollView.frame
        self.feedController.view.frame = CGRect(
            x: self.view.frame.size.width * 2,
            y: 0,
            width: self.scrollView.frame.size.width,
            height: self.scrollView.frame.height
        )
        self.scrollView.addSubview(self.categoriesCtrl.view)
        self.scrollView.addSubview(self.historyCtrl.view)
        self.scrollView.addSubview(self.feedController.view)
        //scrollToPage(1, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        APIClient.getFeed()

        self.pages.layer.cornerRadius = 18.0
        self.pages.layer.shadowColor = UIColor.blackColor().CGColor
        self.pages.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.pages.layer.shadowOpacity = 1.0

        self.scrollView.pagingEnabled = true

        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(
            width: self.scrollView.frame.size.width * 2,
            height: 10
        )

        let statusBG = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 21))
        statusBG.backgroundColor = UIColor.blackColor()
        view.addSubview(statusBG)
    }

    @IBAction func showPage(sender: UIButton) {
        scrollToPage(sender.tag, animated: true)
    }

    func setButtonActive(index: Int) {
        switch index {
        case 0:
            self.historyButton.alpha = 1
            self.categoriesButton.alpha = 0.5
            self.feedButton.alpha = 0.5
        case 1:
            self.historyButton.alpha = 0.5
            self.categoriesButton.alpha = 1
            self.feedButton.alpha = 0.5
        case 2:
            self.historyButton.alpha = 0.5
            self.categoriesButton.alpha = 0.5
            self.feedButton.alpha = 1
        default: break
        }
    }

    func scrollToPage(index: Int, animated: Bool) {
        self.scrollView.scrollRectToVisible(
            CGRect(
                x: self.scrollView.frame.size.width * CGFloat(index),
                y: 0,
                width: self.scrollView.frame.size.width,
                height: 1
            ),
            animated: animated
        )
    }

    //MARK: - Scroll view stuff

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let toPage = Int(
            scrollView.contentOffset.x / self.view.frame.size.width
        )
        setButtonActive(toPage)
    }
}