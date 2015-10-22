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

    init() {
        super.init(nibName: "MainViewController", bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        scrollToPage(1, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pages.layer.cornerRadius = 18.0
        self.pages.layer.shadowColor = UIColor.blackColor().CGColor
        self.pages.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.pages.layer.shadowOpacity = 1.0

        self.scrollView.pagingEnabled = true

        self.categoriesCtrl = CategoriesController()
        self.categoriesCtrl.view.frame = CGRect(
            x: self.categoriesCtrl.view.frame.size.width / 1.6,
            y: 0,
            width: self.categoriesCtrl.view.frame.size.width,
            height: self.categoriesCtrl.view.frame.size.height
        )
        self.scrollView.addSubview(self.categoriesCtrl.view)
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(
            width: self.categoriesCtrl.view.frame.size.width * 2,
            height: self.categoriesCtrl.view.frame.size.height
        )
        super.viewDidLoad()
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
                x: self.view.frame.size.width * CGFloat(index),
                y: 0,
                width: self.view.frame.size.width,
                height: self.view.frame.size.height
            ),
            animated: animated
        )
    }

    //MARK: - Scroll view stuff

    func scrollViewDidScroll(scrollView: UIScrollView) {
        let toPage = Int(
            scrollView.contentOffset.x / self.categoriesCtrl.view.frame.size.width
        )
        setButtonActive(toPage)
    }
}