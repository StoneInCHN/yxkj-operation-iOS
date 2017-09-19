//
//  Enum.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/13.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation

enum StatusType: String {
    case loginInValid = "1001"
    case error404 = "-1011"
    case timeout = "-1001"
    case disconnect = "-1009"
    case pointUnavailable = "2001"
    case success = "0000"
}
