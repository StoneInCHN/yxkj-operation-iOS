//
//  MessageViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/30.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class MessageViewModel {
     var messages = Variable<[Message]>([])
    var messageDetails = Variable<[MessageDetail]>([])
    fileprivate var disposeBag = DisposeBag()
    
    func requestMessages() {
        let param = MessageSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let resposeeObj: Observable<BaseResponseObject<MessageGroup>> = RequestManager.reqeust(.endpoint(MessageSession.getMessage, param: param), needToken: .true)
       resposeeObj
            .map { $0.object?.groups ?? []}
            .subscribe(onNext: {[weak self] (messages) in
                self?.messages.value.append(contentsOf: messages)
            }, onError: { (error) in
                if let error = error as? AppError {
                     HUD.showError(error.message)
                }
        }).disposed(by: disposeBag)

    }
    
    func requestMessageDetail(_ param: MessageSessionParam) {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let resposeeObj: Observable<BaseResponseObject<MessageDetailGroup>> = RequestManager.reqeust(.endpoint(MessageSession.getMessageDetails, param: param))
        resposeeObj
            .map { $0.object?.groups ?? []}
            .subscribe(onNext: {[weak self] (messageDetails) in
                self?.messageDetails.value.append(contentsOf: messageDetails)
                }, onError: { (error) in
                    if let error = error as? AppError {
                        HUD.showError(error.message)
                    }
            })
            .disposed(by: disposeBag)
    }
}
