//
//  LoginViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class LoginViewController: BaseViewController {
    fileprivate lazy  var companyIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "bg"))
        imageView.contentMode = .scaleAspectFit
    
        return imageView
    }()
    
    fileprivate lazy  var phoneNumTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = "请输入您的手机号"
        textField.font = UIFont.sizeToFit(with: 14)
        textField.textColor = UIColor(hex: 0x222222)
        textField.keyboardType = .numberPad
        textField.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        //        textField.text = "15608066219"
        return textField
    }()
    fileprivate lazy   var pwdTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "请输入您的登录密码"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        //        pwdTF.text = "123456"
        return pwdTF
    }()
    fileprivate lazy  var userIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_account"))
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy   var captchdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.setTitle("短信验证码登录", for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0x999999), for: .normal)
         forgetPwdBtn.setTitleColor(UIColor(hex: 0xfbc205), for: .highlighted)
        return forgetPwdBtn
    }()
    fileprivate lazy   var forgetPwdBtn: UIButton = {
        let forgetPwdBtn = UIButton()
        forgetPwdBtn.sizeToFit()
        forgetPwdBtn.titleLabel?.font = UIFont.sizeToFit(with: 14)
        forgetPwdBtn.setTitle("忘记密码?", for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0xfbc205), for: .normal)
        forgetPwdBtn.setTitleColor(UIColor(hex: 0x999999), for: .highlighted)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        if UIDevice.current.modelName == "iPhone X" {
             companyIcon.snp.updateConstraints {  $0.top.equalTo(-64) }
        }
       
    }
    
}

extension LoginViewController {
    fileprivate func setupUI() {
        navigationItem.title = "登录"
        view.backgroundColor = .white
        view.addSubview(companyIcon)
        view.addSubview(userIcon)
        view.addSubview(phoneNumTF)
        view.addSubview(line0)
        view.addSubview(pwdIcon)
        view.addSubview(pwdTF)
        view.addSubview(forgetPwdBtn)
        view.addSubview(line2)
        view.addSubview(loginBtn)
        view.addSubview(captchdBtn)
        companyIcon.snp.makeConstraints { (maker) in
            maker.left.right.top.equalTo(0)
            maker.height.equalTo(185.5.fitHeight)
        }
        
        userIcon.snp.makeConstraints { (maker) in
            maker.top.equalTo(companyIcon.snp.bottom).offset(55)
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
            maker.height.equalTo(1)
        }
        pwdIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(userIcon.snp.left)
            maker.top.equalTo(line0.snp.bottom).offset(12)
            maker.width.equalTo(20)
        }
     
        pwdTF.snp.makeConstraints { (maker) in
            maker.left.equalTo(phoneNumTF.snp.left)
            maker.right.equalTo(phoneNumTF.snp.right)
            maker.top.equalTo(line0.snp.bottom).offset(12)
        }
        line2.snp.makeConstraints { (maker) in
            maker.top.equalTo(pwdIcon.snp.bottom).offset(12)
            maker.left.equalTo(line0.snp.left)
            maker.right.equalTo(line0.snp.right)
            maker.height.equalTo(1)
        }
        loginBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(line2.snp.bottom).offset(50)
            maker.left.equalTo(10)
            maker.right.equalTo(-10)
            maker.height.equalTo(40)
        }
        captchdBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(loginBtn.snp.bottom).offset(120.0.fitHeight)
            maker.centerX.equalTo(loginBtn.snp.centerX)
            maker.height.equalTo(30)
        }
        forgetPwdBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(captchdBtn.snp.bottom).offset(32.0.fitHeight)
            maker.centerX.equalTo(loginBtn.snp.centerX)
            maker.height.equalTo(30)
        }
    }
    
    fileprivate func setupRx() {
        let usernameValid = phoneNumTF.rx.text.orEmpty
            .map { $0.characters.count >= 11}
            .shareReplay(2)
        
        let passwordValid = pwdTF.rx.text.orEmpty
            .map { $0.characters.count >= 6 }
            .shareReplay(1)
        
        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        everythingValid
            .bind(to: loginBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        pwdTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count < 20 ? text: String(text[..<text.index(text.startIndex, offsetBy: 20)])
            }
            .shareReplay(1)
            .bind(to: pwdTF.rx.text)
            .disposed(by: disposeBag)
        
        phoneNumTF.rx.text.orEmpty
            .map { (text) -> String in
                return text.characters.count <= 11 ? text: String(text[..<text.index(text.startIndex, offsetBy: 11)])
            }
            .shareReplay(1)
            .bind(to: phoneNumTF.rx.text)
            .disposed(by: disposeBag)
        
        captchdBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                let vcc = CaptchaLoginVC()
                vcc.phoneNumber = self?.phoneNumTF.text
                self?.navigationController?.pushViewController(vcc, animated: true)
            })
            .disposed(by: disposeBag)
        
        loginBtn.rx.tap
            .subscribe(onNext: { [weak self] in
                print(self.debugDescription)
            })
            .disposed(by: disposeBag)
    }
}
