//
//  ReplenishHistoryCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class ReplenishHistoryCell: UITableViewCell, ViewNameReusable {
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
    
    fileprivate lazy  var timeLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 14)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "12:54:36"
        descLabel.textAlignment = .center
        return descLabel
    }()
    
    fileprivate lazy  var addressLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 0
        descLabel.text = "香年广场T1    编号：4"
        return descLabel
    }()
    
    fileprivate lazy  var goodsCountLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 0
         descLabel.textAlignment = .center
        descLabel.text = "总待补数：50\n总补货数：4\n缺货数:10"
        return descLabel
    }()
    fileprivate lazy  var dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius =  3
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.gray
        return view
    }()
    fileprivate lazy  var bgView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius =  5
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dotView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(line0)
        contentView.addSubview(line1)
        contentView.addSubview(bgView)
        bgView.addSubview(addressLabel)
        bgView.addSubview(goodsCountLabel)
        
        dotView.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contentView.snp.left).offset(75)
            maker.top.equalTo(12)
            maker.size.equalTo(CGSize(width: 6, height: 6))
        }
        line0.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.bottom.equalTo(dotView.snp.top)
            maker.width.equalTo(2)
            maker.centerX.equalTo(dotView.snp.centerX)
        }
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(line0.snp.left)
            maker.top.equalTo(dotView.snp.bottom)
            maker.bottom.equalTo(0)
            maker.width.equalTo(2)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(dotView.snp.left)
            maker.centerY.equalTo(dotView.snp.centerY)
        }
        bgView.snp.makeConstraints { (maker) in
            maker.right.equalTo(-30)
            maker.left.equalTo(dotView.snp.right).offset(12)
            maker.top.equalTo(0)
            maker.bottom.equalTo(-12)
        }
        addressLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.left.equalTo(24)
            maker.top.equalTo(12)
            maker.height.equalTo(30)
        }
        goodsCountLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(0)
            maker.left.equalTo(0)
            maker.top.equalTo(addressLabel.snp.bottom)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
