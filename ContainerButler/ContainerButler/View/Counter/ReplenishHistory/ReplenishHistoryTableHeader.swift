//
//  ReplenishHistoryTableHeader.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class ReplenishHistoryTableHeader: UITableViewHeaderFooterView, ViewNameReusable {
    fileprivate lazy  var dateLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "10.11"
        return descLabel
    }()
    
    fileprivate lazy  var goodsCountLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "总待补数：50  总补货数：4"
        return descLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(goodsCountLabel)
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(15.5)
            maker.centerY.equalTo(contentView.snp.centerY).offset(8)
        }
        goodsCountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel.snp.right).offset(18)
            maker.centerY.equalTo(contentView.snp.centerY).offset(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
