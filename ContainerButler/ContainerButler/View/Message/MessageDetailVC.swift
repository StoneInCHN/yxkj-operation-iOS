//
//  MessageDetailVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/22.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  消息详情

import UIKit
import UIKit
import RxSwift
import RxCocoa

class MessageDetailVC: BaseViewController {
    var messageType: MessageType = .none
    fileprivate lazy var messageVM: MessageViewModel = {[unowned self] in
        let messageVM = MessageViewModel()
        return messageVM
    }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
         taleView.separatorStyle = .none
          taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
}

extension MessageDetailVC {
    fileprivate func setupUI() {
        title = messageType.title
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {
        let param = MessageSessionParam()
        param.type = messageType
        messageVM.requestMessageDetail(param)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        let items = messageVM.messageDetails.asObservable()
        items
            .bind(to: tableView.rx.items(cellIdentifier: "MessageCell", cellType: MessageCell.self)) { (row, element, cell) in
            }
            .disposed(by: disposeBag)
    }
}

extension MessageDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
