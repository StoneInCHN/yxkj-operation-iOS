//
//  Network.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire

public class Header: Model {
    public var token: String {
        get { return  UserSessionInfo.share.token ?? "" }
        set { }
    }
    public var contentType: String = "application/json"
    
    public override func mapping(map: Map) {
        token <- map["token"]
        contentType <- map["Content-Type"]
    }
}

enum UserSession: UserEndPointProtocol {
    
    /// 忘记密码身份验证
    case forgetPwd
    ///  获取公钥
    case getPublicKey
    /// 获取验证码
    case getVerificationCode
    ///  用户密码登录
    case loginByPwd
    /// 用户验证码登录
    case loginByVft
    /// 重置密码
    case resetPwd
    /// 修改密码
    case updatePwd
    /// 忘记密码时验证码验证
    case verifyForgetPwdCaptchCode
    
    var path: String {
        return "/keeper"
    }
    
    var endpoint: String {
        switch self {
        case .forgetPwd:
            return "/forgetPwd"
        case .getPublicKey:
            return "/getPublicKey"
        case .getVerificationCode:
            return "/getVerificationCode"
        case .loginByPwd:
            return "/loginByPwd"
        case .loginByVft:
            return "/loginByVft"
        case .resetPwd:
            return "/resetPwd"
        case .updatePwd:
            return "/updatePwd"
        case .verifyForgetPwdCaptchCode:
            return "/forgetPwd"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getPublicKey:
            return .get
        default:
            return .post
        }
    }
}

class UserSessionParam: Model {
    var phoneNum: String?
    var newPwd: String?
    var oldPwd: String?
    var password: String?
    var userName: String?
    var verificationCode: String?
    
    override func mapping(map: Map) {
        phoneNum <- map["cellPhoneNum"]
        newPwd <- map["cellPhoneNum"]
        oldPwd <- map["oldPwd"]
        password <- map["password"]
        userName <- map["userName"]
        verificationCode <- map["verificationCode"]
    }
}
