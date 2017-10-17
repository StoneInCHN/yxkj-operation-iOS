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
    var rsaPublickey: String = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCBMPGboxzPh9SApXHBKMQHF31rgB6LQBZxg3VirK9Rbp0qvgIDw+2ygZxPQAkgiK24PTWuBbw2UTNy5NxglSCsCnY8+vJXd8cwZKrBpnwXEcO0Wuh5G8Z++X0AIisMCIoiDZZwWnvqJ7a3vUQIj62qTX259s0UqvjGA7uvoDM9tQIDAQAB"
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    /// 获取公钥
    func loadRSAPublickey() {
        let keyOberable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.getPublicKey, param: nil), needToken: .false)
        keyOberable.subscribe(onNext: {[weak self] (response) in
            if let key = response.description {
//                self?.rsaPublickey = key
            }
        })
        .disposed(by: disposeBag)
    }
    
    /// 登录
    func handle(with type: UserSessionHandleType) -> Observable<NullDataResponse> {
        let loginObserable: Observable<NullDataResponse> = RequestManager.reqeust(type.router, needToken: .false)
        return loginObserable
    }
    
    /// 获取验证码
    func getLoginVerificationCode(_ param: UserSessionParam) {
        let codeObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.getVerificationCode, param: param), needToken: .true)
        codeObserable.subscribe(onNext: {_ in    }).disposed(by: disposeBag)

    }
    
}
