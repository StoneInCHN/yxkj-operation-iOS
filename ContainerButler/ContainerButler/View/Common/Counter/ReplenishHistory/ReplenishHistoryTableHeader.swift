//
//  ReplenishHistoryTableHeader.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class ReplenishHistoryTableHeader: UITableViewHeaderFooterView, ViewNameReusable {
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    fileprivate lazy  var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    fileprivate lazy  var dateLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.layer.cornerRadius = 25
        descLabel.layer.masksToBounds = true
        descLabel.font = UIFont.boldSystemFont(ofSize: 17)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "27/08"
        descLabel.textAlignment = .center
        descLabel.backgroundColor = UIColor.gray
        return descLabel
    }()
    
    fileprivate lazy  var goodsCountLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 0
        descLabel.text = "总待补数：50     总补货数：4"
        return descLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(goodsCountLabel)
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(50)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        dateLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(50)
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.size.equalTo(CGSize(width: 50, height: 50))
        }
        goodsCountLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(dateLabel.snp.right).offset(12)
            maker.centerY.equalTo(contentView.snp.centerY)
        }
        contentView.addSubview(line1)
        line1.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(0)
            maker.top.equalTo(dateLabel.snp.bottom)
            maker.centerX.equalTo(dateLabel.snp.centerX)
            maker.width.equalTo(2)
        }
         contentView.addSubview(line0)
        line0.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(dateLabel.snp.top)
            maker.top.equalTo(0)
            maker.centerX.equalTo(dateLabel.snp.centerX)
            maker.width.equalTo(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
