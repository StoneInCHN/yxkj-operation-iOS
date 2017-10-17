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
    
    func loadRSAPublickey() {
        let keyOberable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.getPublicKey, param: nil), needToken: .false)
        keyOberable.subscribe(onNext: { (response) in
            print(response.description ?? "")

        })
        .disposed(by: disposeBag)
    }
    
    func loaginWithPassword(_ param: UserSessionParam) -> Observable<NullDataResponse> {
        let loginObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(UserSession.loginByPwd, param: param), needToken: .false)
        return loginObserable
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









