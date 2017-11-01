//
//  GoodListCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
// swiftlint:disable empty_count

import UIKit
import RxCocoa
import RxSwift
import MGSwipeTableCell
import Kingfisher

class GoodListCell: MGSwipeTableCell, ViewNameReusable {
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
        let selectedView = UIView()
        selectedBackgroundView = selectedView
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
            maker.top.equalTo(5)
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
        
        notReplenishLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(numberLabel.snp.bottom).offset(10)
            maker.right.equalTo(-12)
            
        }
        
        remainReplenishLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(notReplenishLabel.snp.centerY)
            maker.left.equalTo(nameLabel.snp.left)
        }
        
        coverView.snp.makeConstraints {
            $0.left.equalTo(bgView.snp.left)
            $0.right.equalTo(bgView.snp.right)
            $0.top.equalTo(bgView.snp.top)
            $0.bottom.equalTo(bgView.snp.bottom)
        }
        descLabel.snp.makeConstraints {
            $0.centerX.equalTo(UIScreen.width * 0.5)
            $0.centerY.equalTo(bgView.snp.centerY)
        }
         descLabel.sizeToFit()
         coverView.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension GoodListCell {
    func configWaitSupplyGoods(_ goods: Goods) {
        icon.kf.setImage(with: URL(string: goods.goodsPic ?? ""), placeholder: UIImage(named: "drink"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = goods.goodsName
        numberLabel.textColor = UIColor(hex: 0x999999)
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        numberLabel.text = "商品条码：" + (goods.goodsSn ?? "")
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "待补货数:  ")
        text3.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text3.yy_color = UIColor(hex: 0x666666)
        let text4 = NSMutableAttributedString(string: "\(goods.waitSupplyCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text4.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text2.append(text3)
        text2.append(text4)
        remainReplenishLabel.attributedText = text2
        notReplenishLabel.isHidden = true
    }
    
    func configContainerWaitSupplyGoods(_ goods: Goods) {
        icon.kf.setImage(with: URL(string: goods.goodsPic ?? ""), placeholder: UIImage(named: "drink"), options: nil, progressBlock: nil, completionHandler: nil)
        nameLabel.text = goods.goodsName
        numberLabel.textColor = UIColor(hex: 0x000000)
        numberLabel.font = UIFont.systemFont(ofSize: 14)
        numberLabel.text = (goods.goodsSn ?? "")
        let text2 = NSMutableAttributedString()
        let text3 = NSMutableAttributedString(string: "剩余数量:  ")
        text3.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text3.yy_color = UIColor(hex: 0x666666)
        let text4 = NSMutableAttributedString(string: "\(goods.remainCount)")
        text4.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text4.yy_color = UIColor(hex: 0x30C7AC)
        text2.append(text3)
        text2.append(text4)
        notReplenishLabel.attributedText = text2
        
        let text = NSMutableAttributedString()
        let text0 = NSMutableAttributedString(string: "待补货数:  ")
        text0.yy_font = UIFont.boldSystemFont(ofSize: 12)
        text0.yy_color = UIColor(hex: 0x666666)
        let text1 = NSMutableAttributedString(string: "\(goods.waitSupplyCount)")
        text1.yy_font = UIFont.boldSystemFont(ofSize: 16)
        text1.yy_color = UIColor(hex: CustomKey.Color.mainOrangeColor)
        text.append(text0)
        text.append(text1)
        remainReplenishLabel.attributedText = text
    }
    
    func showCover(_ count: Int, text: String? = "已补货") {
        descLabel.text = text
        coverView.isHidden = false
        if count <= 0 {
           badgeView.isHidden = true
        } else {
            badgeView.isHidden = false
            badgeView.badgeValue = count
        }
    }
    
    func hiddenCover() {
        coverView.isHidden = true
    }
}
