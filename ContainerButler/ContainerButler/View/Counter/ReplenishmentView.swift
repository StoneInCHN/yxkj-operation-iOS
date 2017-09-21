//
//  ReplenishmentView.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/20.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import pop

class ReplenishmentView: UIView {
    var replenishAction: (() -> Void)?
    fileprivate let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy  var nameLabel: UILabel = {[weak self] in
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "花样年T3有享控件"
        descLabel.isUserInteractionEnabled = true
        return descLabel
        }()
    fileprivate lazy  var numberLabel: UILabel = {[weak self] in
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "编号001"
        return descLabel
        }()
    fileprivate lazy  var containerLabel: UILabel = {[weak self] in
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "A货柜"
        descLabel.isUserInteractionEnabled = true
        return descLabel
        }()
    fileprivate lazy  var countLabelLabel: UILabel = {[weak self] in
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "缺货总数：9"
        descLabel.isUserInteractionEnabled = true
        return descLabel
        }()
    fileprivate lazy  var descLabel: UILabel = {[weak self] in
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "注：补货时，货柜将暂停服务。"
        return descLabel
        }()
    
    fileprivate lazy  var replenishBtn: UIButton = {[weak self] in
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 16)
        loginBtn.setTitle("开始补货", for: .normal)
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
    
    func show() {
        let positionAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionY)
        positionAnimation?.toValue = superview?.center.y
        positionAnimation?.springBounciness = 10
        let scaleAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleAnimation?.springBounciness = 20
        scaleAnimation?.fromValue = NSValue.init(cgPoint: CGPoint(x: 1.2, y: 1.4))
         scaleAnimation?.toValue = NSValue.init(cgPoint: CGPoint(x: 1.0, y: 1.0))
        if let position = positionAnimation, let scale = scaleAnimation {
            layer.pop_add(position, forKey: "positionAnimation")
            layer.pop_add(scale, forKey: "scaleAnimation")
        }
      
    }
    
    func dismiss() {
        let closeAnimation = POPBasicAnimation(propertyNamed: kPOPLayerPositionY)
        closeAnimation?.duration = 0.5
        closeAnimation?.toValue = 0 - (superview?.layer.position.y ?? 0)
        closeAnimation?.completionBlock = { _, _ in
            
        }
        let scaleDownAnimation = POPSpringAnimation(propertyNamed: kPOPLayerScaleXY)
        scaleDownAnimation?.springBounciness = 20
        scaleDownAnimation?.toValue = NSValue.init(cgPoint: CGPoint(x: 0, y: 0))
        scaleDownAnimation?.completionBlock = {[weak self]_, _ in
            self?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
        if let close = closeAnimation, let scale = scaleDownAnimation {
            layer.pop_add(close, forKey: "closeAnimation")
            layer.pop_add(scale, forKey: "scaleDownAnimation")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ReplenishmentView {
    fileprivate func setupUI() {
        let contanierView = UIView()
        contanierView.layer.cornerRadius = 5
        contanierView.layer.masksToBounds = true
        backgroundColor = .clear
        contanierView.backgroundColor = .white
        addSubview(contanierView)
        contanierView.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.snp.center)
            maker.size.equalTo(CGSize(width: 200, height: 200))
        }
        let btn = UIButton(type: .contactAdd)
        contanierView.addSubview(btn)
        btn.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.top.equalTo(12)
        }
        btn.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss()
            }).disposed(by: disposeBag)
        contanierView.addSubview(nameLabel)
        contanierView.addSubview(numberLabel)
        contanierView.addSubview(containerLabel)
        contanierView.addSubview(countLabelLabel)
        contanierView.addSubview(descLabel)
        contanierView.addSubview(replenishBtn)
        contanierView.addSubview(line0)
        
        nameLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.right.equalTo(-12)
            maker.top.equalTo(24)
        }
        
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.right.equalTo(nameLabel.snp.right)
            maker.top.equalTo(nameLabel.snp.bottom).offset(12)
        }
        containerLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.right.equalTo(nameLabel.snp.right)
            maker.top.equalTo(numberLabel.snp.bottom).offset(12)
        }
        countLabelLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.right.equalTo(nameLabel.snp.right)
            maker.top.equalTo(containerLabel.snp.bottom).offset(12)
        }
        descLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(nameLabel.snp.left)
            maker.right.equalTo(nameLabel.snp.right)
            maker.top.equalTo(countLabelLabel.snp.bottom).offset(12)
        }
        line0.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.height.equalTo(0.5)
            maker.top.equalTo(descLabel.snp.bottom).offset(5)
        }
        replenishBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(line0.snp.bottom).offset(0)
            maker.bottom.equalTo(0)
        }
        
    }
}
