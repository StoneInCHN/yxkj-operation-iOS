//
//  ContainerViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RefreshStatus {
    case none
    case beingHeaderRefresh
    case endHeaderRefresh
    case beingFooterRefresh
    case endFooterRefresh
    case noMoreData
}

class ContainerViewModel {
    fileprivate  let disposeBag: DisposeBag = DisposeBag()
    var requestCommand: PublishSubject<Bool> = PublishSubject<Bool>()
    var models = Variable<[Scence]>([])
    var refreshStatus = Variable<RefreshStatus>(.none)
    var cellHeights: [[CGFloat]] = [[]]
    fileprivate var param: ContainerHomeParam = ContainerHomeParam()
    
    init() {
        requestList()
    }
    
   fileprivate func requestList() {
        requestCommand.subscribe(onNext: { [unowned self](isReloadData) in
            self.param.pageNo = isReloadData ? 1: self.param.pageNo + 1
            let homerObservable: Observable<ContainerHomeResponse> =  RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyState, param: self.param), needToken: .true)
            homerObservable.subscribe({ (event) in
                switch event {
                case  .next( let response):
                    if let scences =  response.object?.scences {
                        if isReloadData {
                             self.models.value = scences
                        } else {
                            if !scences.isEmpty {
                                self.models.value =  self.models.value + scences
                            } else {
                                self.param.pageNo = self.param.pageNo - 1
                            }
                        }
                    }
                   self.cellHeights = self.caculateCellHeights()
                    break
                case .error( let error):
                    if let error = error as? AppError {
                        HUD.showError(error.message)
                    }
                    break
                case .completed:
                    self.refreshStatus.value = isReloadData ? .endHeaderRefresh : .endFooterRefresh
                    break
                }
            }).disposed(by: self.disposeBag)
            
        })
        .disposed(by: disposeBag)
    }
    
fileprivate func caculateCellHeights() -> [[CGFloat]] {
        var scenceHeights: [[CGFloat]] = [[]]
         var heights = [CGFloat]()
        models.value.forEach { scence in
            var height: CGFloat = 0
            let bgViewInset: CGFloat = 12
            let labelTop: CGFloat = 12
            let labelHeight: CGFloat = 16
            let labelBottom: CGFloat = 20
            scence.groups?.forEach { group in
                let topInset: CGFloat = 12.0.fitHeight
                let bottomInset: CGFloat = 22.0.fitHeight
                let itemHeight: CGFloat = 45.0.fitHeight
                if let conatiners = group.containers {
                    let rows: Int = Int(ceil(Double (conatiners.count) / 3.0 ))
                    let minimumLineSpacing: CGFloat = 12.0.fitHeight
                     height = (itemHeight + minimumLineSpacing) * CGFloat(rows)
                }
                height = height + topInset + bottomInset
                height = height + bgViewInset + labelTop + labelHeight + labelBottom
                heights.append(height)
            }
            scenceHeights.append(heights)
        }
       return scenceHeights
    }
}
