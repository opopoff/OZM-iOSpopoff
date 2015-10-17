//
//  MainViewController.swift
//  OZM
//
//  Created by Semyon Novikov on 17/10/15.
//  Copyright © 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pages: UIView!

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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.pages.layer.cornerRadius = 18.0
        self.pages.layer.shadowColor = UIColor.blackColor().CGColor
        self.pages.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        self.pages.layer.shadowOpacity = 1.0

        self.categoriesCtrl = CategoriesController()
        self.scrollView.addSubview(self.categoriesCtrl.view)
    }
}