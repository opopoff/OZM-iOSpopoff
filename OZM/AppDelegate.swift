//
//  AppDelegate.swift
//  OZM
//
//  Created by Semyon Novikov on 19/08/15.
//  Copyright (c) 2015 ozm. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

var navigation: UINavigationController!

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        Fabric.with([Crashlytics.self()])

        navigation = UINavigationController(rootViewController: MainViewController())
        navigation.navigationBar.barStyle = UIBarStyle.Black
        navigation.navigationBar.translucent = true


        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()

        UIApplication.sharedApplication().setStatusBarStyle(
            UIStatusBarStyle.LightContent,
            animated: false
        )

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

