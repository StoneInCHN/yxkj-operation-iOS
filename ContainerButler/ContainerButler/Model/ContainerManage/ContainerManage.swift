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
    var cateId: Int = 0
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
    var waitSupplyCount: Int = 0
    var channelSn: String?
    
    override func mapping(map: Map) {
        goodsSn <- map["goodsSn"]
        goodsName <- map["goodsName"]
        goodsPic <- map["goodsPic"]
        waitSupplyCount <- map["waitSupplyCount"]
        channelSn <- map["channelSn"]
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
    var waitSupplyCount: String?
    var sceneName: String?
    
    override func mapping(map: Map) {
        waitSupplyCount <- map["waitSupplyCount"]
        sceneName <- map["sceneName"]
    }
}



