//
//  NotReplenishViewModel.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/24.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class NotReplenishViewModel {
    
    /// 获取待补优享空间
    func reuestWaitSuppltScenlist() -> Observable<[Scence]> {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<ScenceList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplySceneList, param: param))
       return listObverable.map {$0.object?.groups ?? []}
    }
    
    /// 获取待补商品类别列表
    func requestWaitSupplyGoodsCategoryList() -> Observable<[GoodsCategory]>  {
        let param = ContainerSessionParam()
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsCategoryList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsCategoryList, param: param))
        return listObverable.map {$0.object?.groups ?? []}
    }
    
    ///  获取待补商品清单
    func requestWaitSupplyGoodsList( _ param: ContainerSessionParam) -> Observable<[Goods]>  {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsList, param: param))
        return listObverable.map {$0.object?.groups ?? []}
    }
    
   ///   获取待补商品详
    func requestWaitSupplyGoodsDetail( _ param: ContainerSessionParam) -> Observable<GoodsDetail>  {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<GoodsDetail>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyGoodsDetails, param: param))
        return listObverable.map {$0.object ?? GoodsDetail()}
    }
    
    ///  获取货柜待补商品
    func requestWaitSupplyContainerGoodsList( _ param: ContainerSessionParam) -> Observable<[Goods]>  {
        param.userId = CoreDataManager.sharedInstance.getUserInfo()?.userId
        let listObverable: Observable<BaseResponseObject<WaitSupplyGoodsList>> = RequestManager.reqeust(.endpoint(ContainerSession.getWaitSupplyContainerGoodsList, param: param))
        return listObverable.map {$0.object?.groups ?? []}
    }
}
