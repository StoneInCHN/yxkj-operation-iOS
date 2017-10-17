//
//  UserSessionInfo.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/17.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import Foundation

class UserSessionInfo: NSObject {
    static let share: UserSessionInfo = UserSessionInfo()
    var token: String?
    
    private override init() {
        super.init()
    }
}
