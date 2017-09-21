//
//  GoodListCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class GoodListCell: UITableViewCell, ViewNameReusable {
    let disposeBag: DisposeBag = DisposeBag()
    var itemdidSelected: PublishSubject<String> = PublishSubject<String> ()
    fileprivate lazy  var notReplenishLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "待补货数：2"
        return descLabel
    }()
    fileprivate lazy  var remainReplenishLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "剩余数：2"
        return descLabel
    }()
    fileprivate lazy  var nameLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "统一冰红茶"
        return descLabel
    }()
    
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "A😯"
        return descLabel
    }()
   
    fileprivate lazy  var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_paizza@3x"))
        imageView.contentMode = .center
        return imageView
    }()
    
    fileprivate lazy var badgeView: GIBadgeView = {
        let badgeView = GIBadgeView()
        badgeView.badgeValue = 5
        badgeView.rightOffset = 35
        badgeView.topOffset = 10
        return badgeView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      icon.addSubview(badgeView)
        contentView.addSubview(notReplenishLabel)
        contentView.addSubview(remainReplenishLabel)
        contentView.addSubview(numberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(icon)
        
        notReplenishLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.right.equalTo(-12)
    
        }
        numberLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.left.equalTo(12)
            
        }
        icon.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.left.equalTo(numberLabel.snp.right).offset(12)
            maker.size.equalTo(CGSize(width: 40, height: 40))
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(icon.snp.top).offset(2)
            maker.left.equalTo(icon.snp.right).offset(12)
        }
        remainReplenishLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(icon.snp.bottom).offset(-2)
            maker.left.equalTo(nameLabel.snp.left)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
