//
//  MessageCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/22.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell, ViewNameReusable {
    fileprivate lazy  var messageIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "user_center_paizza"))
        imageView.contentMode = .center
        return imageView
    }()
    fileprivate lazy  var messageTitleLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 0
        descLabel.text = "补货通知          17/8/9 15:25:21"
        return descLabel
    }()
    fileprivate lazy  var messageBodyLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 15)
        descLabel.textColor = UIColor.black
        descLabel.numberOfLines = 0
        descLabel.text = "花样年T3优享空间急需补货15件"
        return descLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(messageIcon)
        contentView.addSubview(messageTitleLabel)
        contentView.addSubview(messageBodyLabel)
        
        messageIcon.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.centerY.equalTo(contentView.snp.centerY)
            maker.size.equalTo(CGSize(width: 40, height: 50))
        }
        
        messageTitleLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(messageIcon.snp.right).offset(12)
            maker.top.equalTo(messageIcon.snp.top).offset(3)
            maker.right.equalTo(-12)
            maker.height.equalTo(20)
        }
        messageBodyLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(messageTitleLabel.snp.left)
            maker.top.equalTo(messageTitleLabel.snp.bottom).offset(10)
            maker.right.equalTo(-12)
            maker.bottom.equalTo(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
