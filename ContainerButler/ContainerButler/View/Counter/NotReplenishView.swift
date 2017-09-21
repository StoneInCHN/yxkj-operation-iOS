//
//  NotReplenishView.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NotReplenishView: UIView {
    var replenishAction: (() -> Void)?
     fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy  var goodsIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "earnings_icon"))
        imageView.contentMode = .center
        return imageView
    }()
    
    fileprivate lazy  var totalNotReplenishLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "总待补数：2"
        return descLabel
    }()
    
    fileprivate lazy  var realDeliveryGoodsLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "实际取货数："
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
    
    fileprivate lazy  var descLabe: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "香年广场T1: 10个   香年广场T1: 10个  \n香年广场T1: 10个   香年广场T1: 10个 "
        return descLabel
    }()
    
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "商品编号：23231231"
        return descLabel
    }()
    
    fileprivate lazy   var  realDeliveryGoodsInputTF: UITextField = {
        let pwdTF = UITextField()
        pwdTF.isSecureTextEntry = true
        pwdTF.placeholder = "00"
        pwdTF.textColor = UIColor(hex: 0x222222)
        pwdTF.font = UIFont.sizeToFit(with: 14)
        pwdTF.tintColor = UIColor(hex: CustomKey.Color.mainColor)
        pwdTF.returnKeyType = .done
        return pwdTF
    }()
    
    fileprivate lazy  var replenishBtn: UIButton = {[weak self] in
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("确定", for: .normal)
        loginBtn.setTitleColor(UIColor.blue, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        if let disposeBag = self?.disposeBag {
            loginBtn.rx.tap.subscribe({ (_) in
                self?.replenishAction?()
            }).disposed(by: disposeBag)
        }
        return loginBtn
        }()
    
    fileprivate lazy  var line0: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe6e6e6)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotReplenishView {
    fileprivate func setupUI() {
        let contanierView = UIView()
        contanierView.layer.cornerRadius = 5
        contanierView.layer.masksToBounds = true
        contanierView.layer.borderWidth = 2
        contanierView.layer.borderColor = UIColor.gray.cgColor
        backgroundColor = .clear
        contanierView.backgroundColor = .white
        contanierView.addSubview(goodsIcon)
        contanierView.addSubview(nameLabel)
        contanierView.addSubview(numberLabel)
        contanierView.addSubview(descLabe)
        contanierView.addSubview(totalNotReplenishLabel)
        contanierView.addSubview(realDeliveryGoodsLabel)
        contanierView.addSubview(realDeliveryGoodsInputTF)
        contanierView.addSubview(line0)
        contanierView.addSubview(replenishBtn)
        addSubview(contanierView)
        contanierView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.snp.center)
            maker.size.equalTo(CGSize(width: 280, height: 300))
        }
        
       goodsIcon.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(contanierView.snp.centerX)
            maker.top.equalTo(12)
            maker.height.equalTo(80)
            maker.width.equalTo(80)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(goodsIcon.snp.centerX)
            maker.top.equalTo(goodsIcon.snp.bottom).offset(12)
        }
        numberLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(goodsIcon.snp.centerX)
            maker.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        descLabe.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(goodsIcon.snp.centerX)
            maker.top.equalTo(numberLabel.snp.bottom).offset(12)
        }
        totalNotReplenishLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(goodsIcon.snp.centerX)
            maker.top.equalTo(descLabe.snp.bottom).offset(12)
        }
        realDeliveryGoodsLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(goodsIcon.snp.centerX)
            maker.top.equalTo(totalNotReplenishLabel.snp.bottom).offset(12)
        }
        realDeliveryGoodsInputTF.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(realDeliveryGoodsLabel.snp.centerY)
            maker.left.equalTo(realDeliveryGoodsLabel.snp.right).offset(8)
            maker.size.equalTo(CGSize(width: 40, height: 30))
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
             maker.right.equalTo(0)
            maker.height.equalTo(0.5)
             maker.top.equalTo(realDeliveryGoodsInputTF.snp.bottom).offset(3)
        }
        replenishBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(line0.snp.bottom).offset(0)
             maker.height.equalTo(50)
        }
    }
}
