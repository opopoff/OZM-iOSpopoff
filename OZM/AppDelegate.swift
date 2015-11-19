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

        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)

        navigation = UINavigationController(rootViewController: SplashController())
        navigation.navigationBar.barStyle = UIBarStyle.BlackOpaque
        navigation.navigationBar.translucent = true

        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()

//        let sdkInstance = VKSdk.initializeWithAppId(VK_APP_ID)
//        sdkInstance.registerDelegate(self)

//        VKSdk.wakeUpSession([VK_PER_MESSAGES], completeBlock: { (state, error) in
//            print("VK wakeup: \(state), \(error)")
//        })

        return true
    }


//    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
//        VKSdk.processOpenURL(url, fromApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as! String)
//        return true
//    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        VKSdk.processOpenURL(url, fromApplication: sourceApplication)
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

