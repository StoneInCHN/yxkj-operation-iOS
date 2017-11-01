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
        view.backgroundColor = UIColor(hex: 0xcccccc)
        return view
    }()
    fileprivate lazy  var line1: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xcccccc)
        return view
    }()
    
    fileprivate lazy  var addressLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 12.5)
        descLabel.textColor = UIColor.mainBlack
        descLabel.numberOfLines = 0
        descLabel.text = "香年广场T1  "
        return descLabel
    }()
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 10)
        descLabel.textColor = UIColor(hex: 0x888888)
        descLabel.numberOfLines = 0
        descLabel.text = "编号(1111111001) "
        return descLabel
    }()
    
    fileprivate lazy  var timeLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .center
        descLabel.font = UIFont.systemFont(ofSize: 10)
        descLabel.textColor = UIColor(hex: 0x888888)
        descLabel.numberOfLines = 0
        descLabel.text = "17:15"
        return descLabel
    }()
    
    fileprivate lazy  var totalNotReplenishLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 11.5)
        descLabel.textColor =  UIColor(hex: 0x555555)
        descLabel.numberOfLines = 0
         descLabel.textAlignment = .center
        descLabel.text = "总待补数：50 "
        return descLabel
    }()
    
    fileprivate lazy  var totalReplenishLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 11.5)
        descLabel.textColor =  UIColor(hex: 0x555555)
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.text = "总补货数：48 "
        return descLabel
    }()
    
    fileprivate lazy  var stockoutLabel: YYLabel = {
        let descLabel = YYLabel()
        descLabel.font = UIFont.systemFont(ofSize: 11.5)
        descLabel.textColor =  UIColor(hex: 0x555555)
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        return descLabel
    }()
    
    fileprivate lazy  var dotView: UIView = {
        let view = UIView()
        view.layer.cornerRadius =  3
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.mainBlack
        return view
    }()
    fileprivate lazy  var bgView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(dotView)
        contentView.addSubview(line0)
        contentView.addSubview(line1)
        contentView.addSubview(bgView)
        bgView.addSubview(addressLabel)
        bgView.addSubview(numberLabel)
        bgView.addSubview(timeLabel)
        bgView.addSubview(totalNotReplenishLabel)
        bgView.addSubview(totalReplenishLabel)
        bgView.addSubview(stockoutLabel)
        
        dotView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.left.equalTo(25)
            maker.size.equalTo(CGSize(width: 6, height: 6))
        }
        
        line0.snp.makeConstraints { (maker) in
            maker.top.equalTo(0)
            maker.bottom.equalTo(dotView.snp.top)
            maker.width.equalTo(1)
            maker.centerX.equalTo(dotView.snp.centerX)
        }
        line1.snp.makeConstraints { (maker) in
            maker.left.equalTo(line0.snp.left)
            maker.top.equalTo(dotView.snp.bottom)
            maker.bottom.equalTo(0)
            maker.width.equalTo(1)
        }
       
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(dotView.snp.right).offset(20)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(0)
            maker.top.equalTo(12)
        }
        
        addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(18)
            maker.top.equalTo(17)
        }
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressLabel.snp.right).offset(27)
            maker.top.equalTo(addressLabel.snp.top)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-30)
            maker.top.equalTo(addressLabel.snp.top)
        }
        
        totalNotReplenishLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(addressLabel.snp.left)
            maker.top.equalTo(addressLabel.snp.bottom).offset(24)
        }
        totalReplenishLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(totalNotReplenishLabel.snp.right).offset(15.0.fitWidth)
            maker.top.equalTo(totalNotReplenishLabel.snp.top)
        }
        stockoutLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(totalReplenishLabel.snp.right).offset(15.0.fitWidth)
            maker.top.equalTo(totalReplenishLabel.snp.top)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(_ model: SuplementRecord) {
        addressLabel.text = model.sceneName
        numberLabel.text = "编号(\(model.sceneSn ?? ""))"
        timeLabel.text = model.supplyTime ?? ""
        
        let text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "总待补数:  ")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x555555)
        let text1 = NSMutableAttributedString(string: "\(model.waitSupplyCount)")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text1.yy_color = UIColor(hex: CustomKey.Color.mainGreenColor)
        text.append(text0)
        text.append(text1)
        totalNotReplenishLabel.attributedText = text
        
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "总补货数: ")
        text3.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text3.yy_color = UIColor(hex: 0x555555)
        let text4 = NSMutableAttributedString(string: "\(model.supplyCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text4.yy_color = UIColor(hex: 0xfbc205)
        text2.append(text3)
        text2.append(text4)
        totalReplenishLabel.attributedText = text2
        
        let text5 = NSMutableAttributedString()
        let text6 = NSMutableAttributedString(string: "缺货数: ")
        text6.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text6.yy_color = UIColor(hex: 0x555555)
        let text7 = NSMutableAttributedString(string: "\(model.lackCount)")
        text7.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text7.yy_color = UIColor(hex: 0xf0282b)
        text5.append(text6)
        text5.append(text7)
        stockoutLabel.attributedText = text5
        
    }
}
