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
    var selectedContainerModels = Variable<[Goods]>([])
    var selectedSenceModels = Variable<[Goods]>([])
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
    var supplyRecords =  Variable<[SuplementRecord]>([])
    fileprivate var moreSupplyRecords: [SuplementRecord] = []
    fileprivate let disposeBag = DisposeBag()
    fileprivate  var moreData: [Goods] = []
    fileprivate var cachedModels: [Goods] {
        if let list = CoreDataManager.sharedInstance.getGoodslist() {
            return list
        }
        return [Goods]()
    }
    
    /// 获取待补优享空间
  func reuestWaitSuppltScencelist() {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<ScenceList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplySceneList, param: param))
        listObverable
            .map { response -> [Scence] in
                let whole = Scence()
                whole.name = "全部"
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
    func requestWaitSupplyGoodsCategoryList() {
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
        requestWaitSupplyGoods(.getWaitSupplyGoodsList)
    }
    
    ///   获取待补商品详情
    func requestWaitSupplyGoodsDetail( _ param: ContainerSessionParam) -> Observable<GoodsDetail> {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<GoodsDetail>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsDetails, param: param))
        return listObverable.map {$0.object ?? GoodsDetail()}
    }
    
    ///  获取货柜待补商品
    func requestWaitSupplyContainerGoodsList() {
         requestWaitSupplyGoods(.getWaitSupplyContainerGoodsList)
    }
    
    ///  提交补货记录
    func requestSupplementRecord(_ param: ContainerSessionParam) -> Observable<NullDataResponse> {
          param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let repsonseObserable: Observable<NullDataResponse> = RequestManager.reqeust(.endpoint(ContainerSession.commitSupplementRecord, param: param))
        return repsonseObserable
    }
    
    /// 上传补货照片
    func uploadSupplementPicture(_ param: ContainerSessionParam, file: Data) -> Observable<NullDataResponse> {
      let  repsonseObserable: Observable<NullDataResponse> =  RequestManager.upload(Router.upload(endpoint: ContainerSession.uploadSupplementPic), param: param,
                              fileData: [file])
        return repsonseObserable
    }
    
    func resetData(_ model: Goods, index: Int) {
        print(cachedModels)
        for goods in cachedModels {
            if goods.goodsSn == model.goodsSn {
                selectedContainerModels.value.remove(at: index)
                models.value.append(goods)
            }
        }
    }

    /// 总补货记录
    func requestSupplyRecords() {
        requestCommand
            .subscribe(onNext: {  [weak self](isReloadData) in
                guard let weakSelf = self else { return }
                weakSelf.param.pageNo = isReloadData ? 1: (weakSelf.param.pageNo ?? 1) + 1
                let listObverable: Observable<BaseResponseObject<SuplementRecordGroup>> = RequestManager.reqeust(.endpoint(ContainerSession.getSupplementSumRecord, param: weakSelf.param))
                listObverable
                    .map {$0.object?.groups ?? []}
                    .subscribe {[weak self] (event) in
                        guard let weakSelf = self else { return }
                        switch event {
                        case .next(let group):
                            if isReloadData {
                                weakSelf.supplyRecords.value = group
                            } else {
                                if !group.isEmpty {
                                    weakSelf.supplyRecords.value =  weakSelf.supplyRecords.value + group
                                    weakSelf.moreSupplyRecords.removeAll()
                                    weakSelf.moreSupplyRecords.append(contentsOf: group)
                                } else {
                                    weakSelf.param.pageNo = (weakSelf.param.pageNo ?? 2) - 1
                                    weakSelf.moreSupplyRecords.removeAll()
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
                                if weakSelf.models.value.count < 20 {
                                    weakSelf.refreshStatus.value = .noMoreData
                                } else {
                                    weakSelf.refreshStatus.value =  .endHeaderRefresh
                                }
                            } else {
                                if weakSelf.moreSupplyRecords.isEmpty {
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
    
    ///  查看补货记录详情
    func requestSupplementRecordDetails(_ param: ContainerSessionParam) -> Observable<BaseResponseObject<ContainerSupplyRecordGroup>> {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let repsonseObserable: Observable<BaseResponseObject<ContainerSupplyRecordGroup>> = RequestManager.reqeust(.endpoint(ContainerSession.getSupplementRecordDetails, param: param))
        return repsonseObserable
    }
}

extension ContainerManageViewModel {
    fileprivate func requestWaitSupplyGoods(_ path: ContainerSession) {
        requestCommand
            .subscribe(onNext: {  [weak self](isReloadData) in
                guard let weakSelf = self else { return }
                weakSelf.param.pageNo = isReloadData ? 1: (weakSelf.param.pageNo ?? 1) + 1
                let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsList>> = RequestManager.reqeust(.endpoint(path, param: weakSelf.param))
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
                            weakSelf.cacheModel()
                             print(weakSelf.cachedModels)
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
                                if weakSelf.models.value.count < 20 {
                                     weakSelf.refreshStatus.value = .noMoreData
                                } else {
                                    weakSelf.refreshStatus.value =  .endHeaderRefresh
                                } 
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
    
    fileprivate func cacheModel() {
        models.value.forEach { (goods) in
          _ = CoreDataManager.sharedInstance.save(goods: goods)
        }
    }
    
}

extension ContainerManageViewModel {
 
}
