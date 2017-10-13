//
//  HUD.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/12.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable function_parameter_count
// swiftlint:disable legacy_constructor

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
        if let title = title {
            let titleText = NSMutableAttributedString(string: title )
            titleText.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15)], range: NSMakeRange(0, title.characters.count))
            alertVC.setValue(titleText, forKey: "attributedTitle")
        }
        if let message = message {
            let messageText = NSMutableAttributedString(string: "\n" + message )
            messageText.addAttributes([NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor(hex: 0x333333)], range: NSMakeRange(0, message.characters.count + 1))
            alertVC.setValue(messageText, forKey: "attributedMessage")
        }
        let cancleAction = UIAlertAction(title: cancleTitle, style: .default, handler: { (_) in
            cancleAction?()
        })
       cancleAction.setValue(UIColor(hex: 0x333333), forKey: "titleTextColor")
        if let enter = enterTitle, !enter.isEmpty {
            let enterAction = UIAlertAction(title: enter, style: .default, handler: { (_) in
                enterAction?()
            })
            alertVC.addAction(enterAction)
             enterAction.setValue(UIColor(hex: 0x333333), forKey: "titleTextColor")
        }
         alertVC.addAction(cancleAction)
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
