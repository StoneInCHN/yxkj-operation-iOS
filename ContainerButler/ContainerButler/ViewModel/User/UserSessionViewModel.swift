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
                UserSessionInfo.share.token = token
            }
        }).disposed(by: disposeBag)
        return loginObserable
    }
    
    /// 获取验证码
    func getLoginVerificationCode(_ param: UserSessionParam) {
        let codeObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.getVerificationCode, param: param), needToken: .true)
        codeObserable.subscribe(onNext: {_ in    }).disposed(by: disposeBag)

    }
    
}
