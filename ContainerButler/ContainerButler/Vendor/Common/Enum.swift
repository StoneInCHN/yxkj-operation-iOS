//
//  Enum.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation

enum RefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

enum CaptchaCodeType: String {
    case login = "login"
    case resetPassword = "resetPwd"
}

enum StatusType: String {
    case loginInValid = "1003201"
    case error404 = "-1011"
    case timeout = "-1001"
    case disconnect = "-1009"
    case pointUnavailable = "2001"
    case success = "0000"
    case none = "0001"
    case phoneNumError = "1001"
    case passwordError = "1002"
    case capchaError = "1003"
    case resetPasswordError = "005"
}


/// 登录类型
enum UserSessionHandleType {
    case loginWithPassword(UserSessionParam)
    case loginWithVerificationCode(UserSessionParam)
    case getVerifedCode(UserSessionParam)
    case verifyForgetPwdCaptchCode(UserSessionParam)
    case resetPasswod(UserSessionParam)
    
    var router: Router {
        switch self {
        case .loginWithPassword(let param):
            return .endpoint(UserSession.loginByPwd, param: param)
        case .loginWithVerificationCode(let param):
            return .endpoint(UserSession.loginByVft, param: param)
        case .getVerifedCode(let param):
            return .endpoint(UserSession.getVerificationCode, param: param)
        case .verifyForgetPwdCaptchCode(let param):
            return .endpoint(UserSession.forgetPwd, param: param)
        case .resetPasswod(let param):
            return .endpoint(UserSession.resetPwd, param: param)
        }
    }
}
