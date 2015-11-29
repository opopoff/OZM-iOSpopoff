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
import VKSdkFramework

var navigation: UINavigationController!

let VK_APP_ID = "5152823"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow!

    func application(
        application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        Fabric.with([Crashlytics.self()])
        Localytics.autoIntegrate(
            "f07632304133cf1b89fbedf-0fe0d7ee-9680-11e5-a1ea-003e57fecdee",
            launchOptions: launchOptions
        )
        Localytics.tagEvent("OPEN_APP", attributes: ["OPEN_APP": "direct"])

        UIApplication
            .sharedApplication()
            .setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)

        UIApplication
            .sharedApplication()
            .setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)

        navigation = UINavigationController(rootViewController: SplashController())
        navigation.navigationBar.barStyle = UIBarStyle.BlackOpaque
        navigation.navigationBar.translucent = true

        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.redColor(),
            NSFontAttributeName: UIFont(name: "Gill Sans", size: 24)!
        ]

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()

        return true
    }


    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        Localytics.tagEvent("OPEN_APP", attributes: ["OPEN_APP": "url"])
        VKSdk.processOpenURL(url, fromApplication: sourceApplication)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
        Localytics.tagEvent("OPEN_APP", attributes: ["OPEN_APP": "direct"])
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}

