//
//  CounterSectionHeaderView.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/20.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CounterSectionHeaderView: UITableViewHeaderFooterView, ViewNameReusable {
    var listTapAction: (() -> Void)?
    let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "编号1"
        return descLabel
    }()
    
    fileprivate lazy  var nameLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "编号1"
        return descLabel
    }()
    
    fileprivate lazy  var listLabel: UILabel = {[weak self] in
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "编号1"
        descLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        descLabel.addGestureRecognizer(tap)
        tap.rx.event
            .subscribe(onNext: { (_) in
                self?.listTapAction?()
            }).disposed(by: disposeBag)
        return descLabel
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.randomColor
        contentView.addSubview(numberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(listLabel)
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(self.snp.centerY)
        }
        nameLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self.snp.centerX)
            maker.centerY.equalTo(self.snp.centerY)
        }
        listLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(-12)
            maker.centerY.equalTo(self.snp.centerY)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
