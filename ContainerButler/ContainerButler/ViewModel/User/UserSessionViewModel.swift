//
//  UserSessionViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/17.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import ObjectMapper

class UserSessionViewModel {
    var rsaPublickey: String? {
        return (UIApplication.shared.delegate as? AppDelegate)?.rsaPublickey
    }
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    
    func saveUserInfo(_ info: BaseResponseObject<UserInfo>, phoneNum: String) {
        if  info.status == .success, let token = info.token, !token.isEmpty, let userInfo = info.object {
            let session = UserSessionInfo()
            session.token = token
            CoreDataManager.sharedInstance.save(userSession: session)
            CoreDataManager.sharedInstance.save(userInfo: userInfo, phoneNum: phoneNum)
        }
    }
    
    func saveSessionInfo(_ info: NullDataResponse) {
        if  info.status == .success, let token = info.token, !token.isEmpty {
            let session = UserSessionInfo()
            session.token = token
            CoreDataManager.sharedInstance.save(userSession: session)
        }
    }
    
    func handle(with type: UserSessionHandleType) -> Observable<NullDataResponse> {
        var needToken: NeedToken = .false
        switch type {
        case .updatePasswod(_):
              needToken = .true
        default:
            needToken = .false
        }
        let loginObserable: Observable<NullDataResponse> = RequestManager.reqeust(type.router, needToken: needToken)
        return loginObserable.map { [weak self](response) -> NullDataResponse in
             self?.saveSessionInfo(response)
              return response
        }
    }
    
    func login(_ param: UserSessionParam) -> Observable<BaseResponseObject<UserInfo>> {
        let loginObserable: Observable<BaseResponseObject<UserInfo>> = RequestManager.reqeust(.endpoint(UserSession.loginByPwd, param: param), needToken: .false)
         return loginObserable.map {  [weak self] (response) -> BaseResponseObject<UserInfo> in
            self?.saveUserInfo(response, phoneNum: param.phoneNum ?? "")
            return response
        }
    }
    
    func resetPassword(_ param: UserSessionParam) -> Observable<BaseResponseObject<UserInfo>> {
        let loginObserable: Observable<BaseResponseObject<UserInfo>> = RequestManager.reqeust(.endpoint(UserSession.resetPwd, param: param), needToken: .false)
        return loginObserable.map { (response) -> BaseResponseObject<UserInfo> in
            if  let token = response.token, !token.isEmpty, let userInfo = response.object {
                let session = UserSessionInfo()
                session.token = token
                CoreDataManager.sharedInstance.save(userSession: session)
                CoreDataManager.sharedInstance.save(userInfo: userInfo, phoneNum: param.phoneNum ?? "")
            }
            return response
        }
    }
    
    func getVerificationCode(_ param: UserSessionParam) -> Observable<NullDataResponse> {
        let codeObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.getVerificationCode, param: param), needToken: .true)
        return codeObserable
    }
    
}
