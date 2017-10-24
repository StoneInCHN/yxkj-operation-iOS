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
        get { return  CoreDataManager.sharedInstance.getSessionInfo()?.token ?? "" }
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

enum ContainerSession: UserEndPointProtocol {
    // 获取货柜待补情况
    case getWaitSupplyState
    
    var endpoint: String {
        switch self {
        case .getWaitSupplyState:
            return "/getWaitSupplyState"
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
    var verifyCodeType: CaptchaCodeType?
    var oldPassword: String?
    var newPassword: String?
    
    override func mapping(map: Map) {
        phoneNum <- map["cellPhoneNum"]
        newPwd <- map["cellPhoneNum"]
        oldPwd <- map["oldPwd"]
        password <- map["password"]
        userName <- map["userName"]
        verificationCode <- map["verificationCode"]
        verifyCodeType <- map["type"]
        oldPassword <- map["oldePwd"]
        newPassword <- map["NewPwd"]
    }
}

class ContainerHomeParam: Model {
    var userId: Int64 = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? -1
    var pageNo: Int = 1
    var pageSize: Int = 20
    
    override func mapping(map: Map) {
        userId <- map["userId"]
        pageNo <- map["pageNo"]
        pageSize <- map["pageSize"]
    }
}
