//
//  MessageHomeVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  消息

import UIKit
import RxSwift
import RxCocoa

class MessageHomeVC: BaseViewController {
    fileprivate lazy var messageVM: MessageViewModel = {
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

extension MessageHomeVC {
    fileprivate func setupUI() {
        title = "消息"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        HUD.showLoading()
        messageVM.requestMessages()
        messageVM.messages.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "MessageCell", cellType: MessageCell.self)) {[weak self] (row, element, cell) in
                HUD.hideLoading()
                cell.config(element)
            }
            .disposed(by: disposeBag)
    }
}

extension MessageHomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(MessageDetailVC(), animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
    
}
