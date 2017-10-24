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
    var rsaPublickey: String?
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    /// 获取公钥
    func loadRSAPublickey() {
        let keyOberable: Observable<BaseResponseObject<RSAKey>> = RequestManager.reqeust(.endpoint(UserSession.getPublicKey, param: nil), needToken: .false)
        keyOberable.subscribe(onNext: {[weak self] (response) in
            if let obj = response.object {
                self?.rsaPublickey = obj.key
            }
        })
        .disposed(by: disposeBag)
    }
    
    func handle(with type: UserSessionHandleType) -> Observable<NullDataResponse> {
        let loginObserable: Observable<NullDataResponse> = RequestManager.reqeust(type.router, needToken: .false)
        loginObserable.subscribe(onNext: { (response) in
            if response.status == .success, let token = response.token, !token.isEmpty {
                let session = UserSessionInfo()
                session.token = token
                CoreDataManager.sharedInstance.save(userSession: session)
            }
        }).disposed(by: disposeBag)
        return loginObserable
    }
    
    func login(_ param: UserSessionParam) -> Observable<BaseResponseObject<UserInfo>> {
        let loginObserable: Observable<BaseResponseObject<UserInfo>> = RequestManager.reqeust(.endpoint(UserSession.loginByPwd, param: param), needToken: .false)
        loginObserable.subscribe(onNext: { (response) in
            if response.status == .success, let token = response.token, !token.isEmpty, let userInfo = response.object {
                let session = UserSessionInfo()
                session.token = token
                CoreDataManager.sharedInstance.save(userSession: session)
                CoreDataManager.sharedInstance.save(userInfo: userInfo)
            }
        }).disposed(by: disposeBag)
        return loginObserable
    }
    
    /// 获取验证码
    func getVerificationCode(_ param: UserSessionParam) {
        let codeObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.getVerificationCode, param: param), needToken: .true)
        codeObserable.subscribe(onNext: {_ in    }).disposed(by: disposeBag)

    }
    
}
