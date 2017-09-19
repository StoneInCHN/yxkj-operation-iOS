//
//  CaptchaLoginVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CaptchaLoginVC: BaseViewController {
    var phoneNumber: String?
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入验证码"
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
    fileprivate lazy   var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        forgetPwdBtn.setTitle("获取验证码", for: .normal)
        forgetPwdBtn.setTitleColor(UIColor.blue, for: .normal)
        forgetPwdBtn.setTitleColor(UIColor.gray, for: .highlighted)
        forgetPwdBtn.setTitleColor(UIColor.gray, for: .disabled)
        return forgetPwdBtn
    }()
    fileprivate lazy  var loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_normal"), for: .normal)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .highlighted)
        loginBtn.setBackgroundImage(UIImage(named: "loginBtn_highlighted"), for: .disabled)
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("登 录", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        loginBtn.isEnabled = false
        return loginBtn
    }()
    fileprivate lazy   var pwdIcon: UIImageView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRx()
    }
}

extension CaptchaLoginVC {
    fileprivate func setupUI() {
        navigationItem.title = "验证码登录"
        phoneNumTF.text = phoneNumber
        view.addSubview(userIcon)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdIcon)
        view.addSubview(pwdTF)
        view.addSubview(line1)
        view.addSubview(forgetPwdBtn)
        view.addSubview(line2)
        view.addSubview(loginBtn)
        
        userIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(73)
            maker.left.equalTo(30)
            maker.width.equalTo(20)
        }
        phoneNumTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.right).offset(20)
            maker.centerY.equalTo(userIcon.snp.centerY)
            maker.right.equalTo(-30)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(20)
            maker.top.equalTo(userIcon.snp.bottom).offset(12)
            maker.right.equalTo(-20)
            maker.height.equalTo(0.5)
        }
        
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(line0.snp.bottom).offset(1)
            maker.right.equalTo(-30)
            maker.height.equalTo(40)
        }
        
        pwdIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left).offset(2)
            maker.top.equalTo(line0.snp.bottom).offset(12)
            maker.width.equalTo(20)
        }
        
        line1.snp.makeConstraints { (maker) in
            maker.right.equalTo(forgetPwdBtn.snp.left).offset(-5)
            maker.width.equalTo(1)
            maker.height.equalTo(20)
            maker.centerY.equalTo(pwdIcon.snp.centerY)
        }
      
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIcon.snp.bottom).offset(12)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(0.5)
        }
        
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(forgetPwdBtn.snp.left).offset(-20)
            maker.top.equalTo(line0.snp.bottom).offset(12)
        }
        
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(line2.snp.bottom).offset(50)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
        }
    }
    
    fileprivate func setupRx() {
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.characters.count >= 11}
            .shareReplay(2)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 4 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 4 ? text: text.substring(to: "0123".endIndex)
            }
            .shareReplay(1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        phoneNumTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 11 ? text: text.substring(to: "15608006621".endIndex)
            }
            .shareReplay(1)
            .bind(to: phoneNumTF.rx.text)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: forgetPwdBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        forgetPwdBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else {    return      }
                HUD.showAlert(from: weakSelf, title: "确认手机号码",
                              message: "我们将发送验证码短信到这个号码：\n +86 \(weakSelf.phoneNumTF.text ?? "")",
                    enterTitle: "好",
                    enterAction: { (_) in
                    weakSelf.forgetPwdBtn.start(withTime: 120, title: "获取验证码", countDownTitle: "S后重发", mainColor: UIColor.white, count: UIColor.white)
                }, cancleAction: nil)
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                print("login:\(self.debugDescription)")
                let vcc = ResetPasswordVC()
                vcc.phoneNumber = self?.phoneNumTF.text
                self?.navigationController?.pushViewController(vcc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
