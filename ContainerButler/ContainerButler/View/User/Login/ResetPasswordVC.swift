//
//  ResetPasswordVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ResetPasswordVC: BaseViewController {
    var phoneNumber: String?
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入您的手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        textField.isEnabled = false
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入新密码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy   var pwdTFAgain: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请再次输入新密码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    fileprivate lazy  var userIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_account"))
        imageView.contentMode = .center
        return imageView
    }()

    fileprivate lazy  var descPwdLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.text = "密码必须至少8个字符，而且同时包含字母和数字"
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    fileprivate lazy  var descPwdLabel0: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(13))
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.text = "如果你已忘记密码，可以在本页面重置密码"
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    fileprivate lazy   var pwdIcon: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_pwd"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    
    fileprivate lazy   var pwdIconAgain: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "user_center_pwd"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy   var line1: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy  var line2: UIView  = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    fileprivate lazy  var enterBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("完成", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .disabled)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.isEnabled = false
        loginBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 35)
        return loginBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }

}

extension ResetPasswordVC {
    fileprivate func setupUI() {
        title = "设置密码"
        phoneNumTF.text = phoneNumber
        view.addSubview(descPwdLabel0)
        view.addSubview(userIcon)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdIcon)
        view.addSubview(pwdTF)
         view.addSubview(pwdIconAgain)
        view.addSubview(pwdTFAgain)
        view.addSubview(line1)
        view.addSubview(line2)
        view.addSubview(descPwdLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: enterBtn)
        descPwdLabel0.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(84)
        }
        userIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(descPwdLabel0.snp.bottom).offset(35)
            maker.width.equalTo(20)
        }
        phoneNumTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(20)
            maker.right.equalTo(view.snp.right).offset(-20)
            maker.height.equalTo(35)
            maker.centerY.equalTo(userIcon.snp.centerY)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(phoneNumTF.snp.bottom).offset(12)
            maker.right.equalTo(-20)
            maker.height.equalTo(0.5)
        }
        
        pwdIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left).offset(2)
            maker.top.equalTo(line0.snp.bottom).offset(12)
            maker.width.equalTo(20)
        }
        
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(phoneNumTF.snp.right)
            maker.top.equalTo(line0.snp.bottom).offset(12)
        }
        
        line1.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIcon.snp.bottom).offset(12)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(0.5)
        }
        
        pwdIconAgain.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left).offset(2)
            maker.top.equalTo(line1.snp.bottom).offset(12)
            maker.width.equalTo(20)
        }
        
        pwdTFAgain.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(phoneNumTF.snp.right)
            maker.top.equalTo(line1.snp.bottom).offset(12)
        }
        
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIconAgain.snp.bottom).offset(12)
            maker.left.equalTo(line1.snp.left)
            maker.right.equalTo(line1.snp.right)
            maker.height.equalTo(0.5)
        }
        
        descPwdLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(descPwdLabel0.snp.left)
            maker.top.equalTo(line2.snp.top).offset(25)
            maker.right.equalTo(-20)
        }
    }
    
     fileprivate func setupRx() {
        let usernameValid = pwdTFAgain.rx.text.orEmpty
            .map { $0.characters.count >= 8}
            .shareReplay(1)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 8 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
         everythingValid
            .bind(to: enterBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        enterBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {    return      }
                weakSelf.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
