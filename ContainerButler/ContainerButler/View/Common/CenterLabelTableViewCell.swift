//
//  CenterLabelTableViewCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/11/2.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class CenterLabelTableViewCell: UITableViewCell, ViewNameReusable {

    var centerLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 14)
        descLabel.textColor = .red
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center
        descLabel.backgroundColor = UIColor.white
        return descLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(centerLabel)
        contentView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        centerLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(contentView.snp.left)
            maker.right.equalTo(contentView.snp.right)
            maker.bottom.equalTo(0)
            maker.top.equalTo(8)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
