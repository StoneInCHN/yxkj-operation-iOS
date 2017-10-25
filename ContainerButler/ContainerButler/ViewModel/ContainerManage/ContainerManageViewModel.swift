//
//  ContainerManage.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/24.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ContainerManageViewModel {
     var models = Variable<[Goods]>([])
    var goodsCategory = Variable([GoodsCategory]())
    var scenceList = Variable([Scence]())
    var requestCommand: PublishSubject<Bool> = PublishSubject<Bool>()
    var refreshStatus = Variable<RefreshStatus>(.none)
   lazy var param: ContainerSessionParam = {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId ?? -1
        param.pageNo = 1
        param.pageSize = 20
        return param
    }()
    fileprivate let disposeBag = DisposeBag()
     fileprivate  var moreData: [Goods] = []
    init() {
        requestWaitSupplyGoodsCategoryList()
        reuestWaitSuppltScencelist()
        requestWaitSupplyGoodsList()
    }
    /// 获取待补优享空间
  fileprivate  func reuestWaitSuppltScencelist() {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<ScenceList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplySceneList, param: param))
        listObverable
            .map { response -> [Scence] in
                let whole = Scence()
                whole.name = "全部"
                whole.number = "0"
                if var groups = response.object?.groups {
                      groups.insert(whole, at: 0)
                    return groups
                }
               return []
            }
            .bind(to: scenceList)
            .disposed(by: disposeBag)
    }
    
    /// 获取待补商品类别列表
  fileprivate  func requestWaitSupplyGoodsCategoryList() {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsCategoryList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsCategoryList, param: param))
        listObverable
            .map { response -> [GoodsCategory] in
                let whole = GoodsCategory()
                whole.cateName = "全部"
                if var groups = response.object?.groups {
                    groups.insert(whole, at: 0)
                    return groups
                }
                return []
            }
        .bind(to: goodsCategory).disposed(by: disposeBag)
    }
    
    ///  获取待补商品清单
    func requestWaitSupplyGoodsList() {
        requestCommand
            .subscribe(onNext: {  [weak self](isReloadData) in
                guard let weakSelf = self else { return }
                 weakSelf.param.pageNo = isReloadData ? 1: (weakSelf.param.pageNo ?? 1) + 1
                let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsList, param: weakSelf.param))
                    listObverable
                    .map {$0.object?.groups ?? []}
                    .subscribe {[weak self] (event) in
                      guard let weakSelf = self else { return }
                        switch event {
                        case .next(let group):
                            if isReloadData {
                                weakSelf.models.value = group
                            } else {
                                if !group.isEmpty {
                                    weakSelf.models.value =  weakSelf.models.value + group
                                    weakSelf.moreData.removeAll()
                                    weakSelf.moreData.append(contentsOf: group)
                                } else {
                                    weakSelf.param.pageNo = (weakSelf.param.pageNo ?? 2) - 1
                                    weakSelf.moreData.removeAll()
                                }
                            }
                            break
                        case .error( let error):
                            if let error = error as? AppError {
                                HUD.showError(error.message)
                               weakSelf.refreshStatus.value = isReloadData ? .endHeaderRefresh: .endFooterRefresh
                            }
                            break
                        case .completed:
                            if isReloadData {
                                weakSelf.refreshStatus.value =  .endHeaderRefresh
                             } else {
                                  if weakSelf.moreData.isEmpty {
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
    
    ///   获取待补商品详情
    func requestWaitSupplyGoodsDetail( _ param: ContainerSessionParam) -> Observable<GoodsDetail> {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<GoodsDetail>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsDetails, param: param))
        return listObverable.map {$0.object ?? GoodsDetail()}
    }
    
    ///  获取货柜待补商品
    func requestWaitSupplyContainerGoodsList( _ param: ContainerSessionParam) -> Observable<[Goods]> {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyContainerGoodsList, param: param))
        return listObverable.map {$0.object?.groups ?? []}
    }
}
