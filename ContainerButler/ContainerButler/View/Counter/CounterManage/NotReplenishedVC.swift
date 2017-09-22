//
//  NotReplenishedVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  待补商品

import UIKit
import RxSwift
import RxCocoa

class NotReplenishedVC: BaseViewController {
    lazy var replenishManageView: ReplenishManageView = {
        let animator = ReplenishManageView()
        animator.replenishAction = { [weak self] in
            
        }
        return animator
    }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension NotReplenishedVC {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
        replenishManageView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        parent?.view.addSubview(replenishManageView)
    }
}

extension NotReplenishedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         replenishManageView.show()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension NotReplenishedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let unReadAction = UITableViewRowAction(style: .normal, title: "标记为未读") { (_, indexPath) in
            
        }
        return [unReadAction]
    }
}
