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
import RxCocoa
import RxSwift
import ObjectMapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var rsaPublickey: String?
    fileprivate let disposeBag = DisposeBag()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupUI()
        chooseRootVC()
        startLocate()
        loadRSAPublickey()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.sharedInstance.saveContext()
    }
}

extension AppDelegate {
    fileprivate func setupUI() {
        UINavigationBar.appearance().tintColor = UIColor.black
        UINavigationBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(hex: CustomKey.Color.tabBackgroundColor)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        if let font = UIFont(name: "PingFangSC-Medium", size: 17) {
            UINavigationBar.appearance().titleTextAttributes =
                [NSAttributedStringKey.foregroundColor: UIColor.black,
                 NSAttributedStringKey.font: font]
        }
        let keyboardManager = IQKeyboardManager.sharedManager()
        keyboardManager.enableAutoToolbar = true
        keyboardManager.enable = true
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.shouldShowToolbarPlaceholder = false
    }
    
    fileprivate func chooseRootVC() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        var rootVC: UIViewController?
        if let token = CoreDataManager.sharedInstance.getSessionInfo()?.token, !token.isEmpty {
            rootVC = TabBarController()
        } else {/// 没有token进行登录
            rootVC = NavigationController(rootViewController: LoginViewController())
        }
        window?.rootViewController = rootVC
        window?.makeKeyAndVisible()
    }
    
    fileprivate func startLocate() {
        Location.share.startLocate()
    }
    
    /// 获取公钥
    func loadRSAPublickey() {
        let keyOberable: Observable<BaseResponseObject<RSAKey>> = RequestManager.reqeust(.endpoint(UserSession.getPublicKey, param: nil), needToken: .false)
        keyOberable.subscribe(onNext: {[weak self] (response) in
            if let obj = response.object {
                self?.rsaPublickey = obj.key
            }
        })
            .disposed(by: disposeBag)
    }
}
