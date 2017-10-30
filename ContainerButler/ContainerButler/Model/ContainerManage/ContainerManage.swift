//
//  ContainerManage.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/24.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

class ScenceList: Model {
    var groups: [Scence]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}

class WaitSupplyGoodsCategoryList: Model {
    var groups: [GoodsCategory]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}

class WaitSupplyGoodsList: Model {
    var groups: [Goods]?
    
    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}

class GoodsCategory: Model {
    var cateId: Int?
    var cateName: String?
    
    override func mapping(map: Map) {
        cateId <- map["cateId"]
        cateName <- map["cateName"]
    }
}

class Goods: Model {
    var goodsSn: String?
    var goodsName: String?
    var goodsPic: String?
    var waitSupplyCount: Int = 1000
    var channelSn: String?
    var isSupplied: Bool = false
    var remainCount: Int = 0
    var supplyCount: Int = 0
     var supplementId: Int = 0
    
    override func mapping(map: Map) {
        goodsSn <- map["goodsSn"]
        goodsName <- map["goodsName"]
        goodsPic <- map["goodsPic"]
        waitSupplyCount <- map["waitSupplyCount"]
        channelSn <- map["channelSn"]
       remainCount <- map["remainCount"]
      supplementId <- map["id"]
    }
    
}

class GoodsDetail: Model {
    var goodsSn: String?
    var goodsName: String?
    var sceneCountList: [WaitSupplySence]?
    var sumCount: Int = 0
    
    override func mapping(map: Map) {
        goodsSn <- map["goodsSn"]
        goodsName <- map["goodsName"]
        sceneCountList <- map["sceneCountList"]
        sumCount <- map["sumCount"]
    }
}

class WaitSupplySence: Model {
    var waitSupplyCount: Int = 0
    var sceneName: String?
    
    override func mapping(map: Map) {
        waitSupplyCount <- map["waitSupplyCount"]
        sceneName <- map["sceneName"]
    }
}

class SuplementRecord: Model {
    var sceneSn: String?
    var sceneName: String?
    var waitSuppTotalCount: Int = 0
    var suppTotalCount: Int = 0
    var lackCount: Int = 0
    var suppEndTime: String?
    
    override func mapping(map: Map) {
        sceneSn <- map["sceneSn"]
        sceneName <- map["sceneName"]
        waitSuppTotalCount <- map["waitSuppTotalCount"]
        suppTotalCount <- map["suppTotalCount"]
        lackCount <- map["lackCount"]
        suppEndTime <- map["suppEndTime"]
    }
}

class SuplementRecordGroup: Model {
      var groups: [SuplementRecord]?
    
     override func mapping(map: Map) {
        groups <- map["group"]
    }
}

class SuplementRecordDetail: Model {
    var channelSn: String?
    var goodsName: String?
    var goodsPic: String?
    var waitSupplyCount: Int = 0
    var supplyCount: Int = 0
    
    override func mapping(map: Map) {
        channelSn <- map["channelSn"]
        goodsName <- map["goodsName"]
        goodsPic <- map["goodsPic"]
        waitSupplyCount <- map["waitSupplyCount"]
        supplyCount <- map["supplyCount"]
    }
}

class ContainerSupplyRecord: Model {
    var cntrSn: String?
    var cntrSupplementRecords: [SuplementRecordDetail]?
    
    override func mapping(map: Map) {
        cntrSn <- map["cntrSn"]
        cntrSupplementRecords <- map["cntrSupplementRecords"]
    }
}

class ContainerSupplyRecordGroup: Model {
    var groups: [ContainerSupplyRecord]?

    override func mapping(map: Map) {
        groups <- map["groups"]
    }
}







