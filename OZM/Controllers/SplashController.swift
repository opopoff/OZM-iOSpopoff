//
//  SplashController.swift
//  OZM
//
//  Created by Semyon Novikov on 11/09/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import Foundation
import UIKit

class SplashController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIClient.registerDevice("test").then { _ in
            self.performSegueWithIdentifier("proceed", sender: nil)
        }
        .catch { error in
            println(error)
        }
    }
}