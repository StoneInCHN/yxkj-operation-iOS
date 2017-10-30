//
//  ReplenishHistoryViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/30.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ReplenishHistoryViewModel {
    var requestCommand: PublishSubject<Bool> = PublishSubject<Bool>()
    var refreshStatus = Variable<RefreshStatus>(.none)
    lazy var param: ContainerSessionParam = {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? -1
        param.pageNo = 1
        param.pageSize = 20
        return param
    }()
    var supplyRecordGroups = Variable<[SuplementRecordGroup]>([])
     var supplyRecordDetailGroups =  Variable<[ContainerSupplyRecord]>([])
    fileprivate var moreSupplyRecordGroupss: [SuplementRecordGroup] = []
    fileprivate let disposeBag = DisposeBag()
    
    func requestSupplyRecords() {
        requestCommand
            .subscribe(onNext: {  [weak self](isReloadData) in
                guard let weakSelf = self else { return }
                weakSelf.param.pageNo = isReloadData ? 1: (weakSelf.param.pageNo ?? 1) + 1
                let listObverable: Observable<BaseResponseObject<RecordGroup>> = RequestManager.reqeust(.endpoint(ContainerSession.getSupplementSumRecord, param: weakSelf.param))
                listObverable
                    .map {$0.object?.groups ?? []}
                    .subscribe {[weak self] (event) in
                        guard let weakSelf = self else { return }
                        switch event {
                        case .next(let groups):
                            if isReloadData {
                                weakSelf.supplyRecordGroups.value = groups
                            } else {
                                if !groups.isEmpty {
                                    weakSelf.supplyRecordGroups.value =  weakSelf.supplyRecordGroups.value + groups
                                    weakSelf.moreSupplyRecordGroupss.removeAll()
                                    weakSelf.moreSupplyRecordGroupss.append(contentsOf: groups)
                                } else {
                                    weakSelf.param.pageNo = (weakSelf.param.pageNo ?? 2) - 1
                                    weakSelf.moreSupplyRecordGroupss.removeAll()
                                }
                            }
                            break
                        case .error( let error):
                            if let error = error as? AppError {
                                HUD.showError(error.message)
                                if isReloadData {
                                    weakSelf.refreshStatus.value =  .endHeaderRefresh
                                } else {
                                    weakSelf.refreshStatus.value =  .endFooterRefresh
                                    weakSelf.param.pageNo = (weakSelf.param.pageNo ?? 2) - 1
                                }
                            }
                            break
                        case .completed:
                            if isReloadData {
                                if weakSelf.supplyRecordGroups.value.count < 20 {
                                    weakSelf.refreshStatus.value = .noMoreData
                                } else {
                                    weakSelf.refreshStatus.value =  .endHeaderRefresh
                                }
                            } else {
                                if weakSelf.moreSupplyRecordGroupss.isEmpty {
                                    weakSelf.refreshStatus.value = .noMoreData
                                } else {
                                    weakSelf.refreshStatus.value =  .endFooterRefresh
                                }
                            }
                            break
                        }
                    }.disposed(by: weakSelf.disposeBag)
            }).disposed(by: disposeBag)
    }
    
    func requestSupplementRecordDetails(_ param: ContainerSessionParam) {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let repsonseObserable: Observable<BaseResponseObject<ContainerSupplyRecordGroup>> = RequestManager.reqeust(.endpoint(ContainerSession.getSupplementRecordDetails, param: param))
        repsonseObserable
            .map {$0.object?.groups ?? []}
            .bind(to: supplyRecordDetailGroups)
            .disposed(by: disposeBag)
    }
    
}
