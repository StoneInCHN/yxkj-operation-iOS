//
//  HUD.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/12.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable function_parameter_count

import UIKit
import SVProgressHUD

class HUD {
    static func showAlert(from currentVC: UIViewController,
                              title: String?,
                              message: String?,
                              enterTitle: String?,
                              cancleTitle: String? = "取消",
                              enterAction: (() -> Void)?,
                              cancleAction: (() -> Void)?) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: cancleTitle, style: .default, handler: { (_) in
            cancleAction?()
        }))
        if let enter = enterTitle, !enter.isEmpty {
            alertVC.addAction(UIAlertAction(title: enter, style: .default, handler: { (_) in
                enterAction?()
            }))
        }
        currentVC.present(alertVC, animated: true, completion: nil)
    }
    
    static func showLoading() {
        SVProgressHUD.setRingNoTextRadius(10)
        SVProgressHUD.show()
        
    }
    
    static func hideLoading() {
        SVProgressHUD.dismiss()
    }
    
    static func showError(_ meessage: String) {
        SVProgressHUD.setMaximumDismissTimeInterval(2)
        SVProgressHUD.showError(withStatus: meessage)
    }
    
    static func showSuccess(_ message: String) {
        SVProgressHUD.showSuccess(withStatus: message)
    }
    
}
