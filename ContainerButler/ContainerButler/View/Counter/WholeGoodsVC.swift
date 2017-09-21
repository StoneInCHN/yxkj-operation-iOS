//
//  WholeGoodsVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  全部商品

import UIKit
import RxSwift
import RxCocoa

class WholeGoodsVC: BaseViewController {
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }

}

extension WholeGoodsVC {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupRX() {
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        items
            .bind(to: tableView.rx.items(cellIdentifier: "GoodListCell", cellType: GoodListCell.self)) { (row, element, cell) in
            }
            .disposed(by: disposeBag)
    }
}

extension WholeGoodsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
