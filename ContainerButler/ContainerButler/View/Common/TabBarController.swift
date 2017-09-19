//
//  TabBarController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/12.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TabBarController {
    fileprivate func add(childVC: UIViewController,
                         title: String?,
                         normalImageName: String,
                         selectedImageName: String) {
        let navi = NavigationController(rootViewController: childVC)
        navi.tabBarItem = UITabBarItem(title: title, image: UIImage(named: normalImageName), selectedImage: UIImage(named: selectedImageName))
        navi.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        addChildViewController(navi)
    }
}
