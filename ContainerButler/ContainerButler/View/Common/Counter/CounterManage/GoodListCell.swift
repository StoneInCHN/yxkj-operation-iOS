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
import YYText

class GoodListCell: UITableViewCell, ViewNameReusable {
    let disposeBag: DisposeBag = DisposeBag()
    var rightPanAction: (() -> Void)?
    var itemdidSelected: PublishSubject<String> = PublishSubject<String> ()
    fileprivate lazy  var notReplenishLabel: YYLabel = {
        let descLabel = YYLabel()
        var text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "待补货数:")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "22")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text.append(text0)
        text.append(text1)
        descLabel.attributedText = text
        return descLabel
    }()
    fileprivate lazy  var remainReplenishLabel: YYLabel = {
        let descLabel = YYLabel()
        var text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "剩余数量:")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "22")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: 0x30C7AC)
        text.append(text0)
        text.append(text1)
        descLabel.attributedText = text
        return descLabel
    }()
    fileprivate lazy  var nameLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 1
        descLabel.text = "统一康师傅冰红绿茶统一康师傅冰红绿... "
        return descLabel
    }()
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 1
        descLabel.text = "A01"
        return descLabel
    }()
    
    fileprivate lazy  var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    fileprivate lazy  var coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
        return view
    }()
    
    fileprivate lazy  var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descLabel.textColor = UIColor.white
        descLabel.numberOfLines = 1
        descLabel.text = "已补货"
        return descLabel
    }()
    
    fileprivate lazy var badgeView: GIBadgeView = {
        let badgeView = GIBadgeView()
        badgeView.badgeValue = 50
        badgeView.rightOffset = 10
        badgeView.backgroundColor = UIColor.lightGray
        return badgeView
    }()
    
    fileprivate lazy  var icon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_paizza@3x"))
        imageView.contentMode = .center
        return imageView
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        contentView.addSubview(bgView)
        bgView.addSubview(notReplenishLabel)
        bgView.addSubview(remainReplenishLabel)
        bgView.addSubview(nameLabel)
        bgView.addSubview(icon)
        bgView.addSubview(numberLabel)
        bgView.addSubview(coverView)
        coverView.addSubview(badgeView)
        coverView.addSubview(descLabel)
        badgeView.topOffset = 40
        badgeView.rightOffset = UIScreen.width - 52
        bgView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(12)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        icon.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.left.equalTo(bgView.snp.left).offset(12)
            maker.size.equalTo(CGSize(width: 40, height: 60))
        }
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(bgView.snp.top).offset(15)
            maker.right.equalTo(bgView.snp.right).offset(-12)
            maker.left.equalTo(icon.snp.right).offset(20)
        }
        numberLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.left.equalTo(nameLabel.snp.left)
        }
        
        remainReplenishLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(numberLabel.snp.bottom).offset(12)
            maker.left.equalTo(nameLabel.snp.left)
             maker.bottom.equalTo(bgView.snp.bottom).offset(-10)
        }
        
        notReplenishLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(remainReplenishLabel.snp.centerY)
            maker.right.equalTo(-12)
    
        }
     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        coverView.frame = CGRect(x: -UIScreen.width, y: 0, width: UIScreen.width, height: bounds.height - 12)
        descLabel.center = CGPoint(x: UIScreen.width * 0.5, y: (bounds.height - 12) * 0.5)
        descLabel.sizeToFit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




