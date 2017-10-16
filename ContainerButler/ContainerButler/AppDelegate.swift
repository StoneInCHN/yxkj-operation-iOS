//
//  AppDelegate.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/11.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupUI()
        chooseRootVC()
        startLocate()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }
}

extension AppDelegate {
    fileprivate func setupUI() {
        UITabBar.appearance().barTintColor = UIColor(hex: CustomKey.Color.tabBackgroundColor)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        if let font = UIFont(name: "PingFangSC-Medium", size: 18) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: UIColor.black,
                 NSAttributedStringKey.font: font]
        }
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = false
        keyboardManager.enable = true
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.shouldShowToolbarPlaceholder = false
    }
    
    fileprivate func chooseRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
//        window?.rootViewController = NavigationController(rootViewController: LoginViewController())
         window?.rootViewController = TabBarController()
        window?.makeKeyAndVisible()
    }
    
    fileprivate func startLocate() {
        Location.share.startLocate()
    }
}
