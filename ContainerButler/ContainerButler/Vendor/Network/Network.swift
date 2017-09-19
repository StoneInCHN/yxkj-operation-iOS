//
//  Network.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation
import ObjectMapper

public class Header: Model {
    public var token: String {
        get { return  "token"}
        set { }
    }
    public var contentType: String = "application/json"
    
    public override func mapping(map: Map) {
        token <- map["token"]
        contentType <- map["Content-Type"]
    }
}
