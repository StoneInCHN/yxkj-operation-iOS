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
import MGSwipeTableCell

class WholeGoodsVC: BaseViewController {
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
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
         tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
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
                cell.delegate = self
            }
            .disposed(by: disposeBag)
    }
}

extension WholeGoodsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}
extension WholeGoodsVC: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        swipeSettings.transition = .border
        return  UIButton.createButtons(with: ["出货测试"], backgroudColors: [UIColor(hex: CustomKey.Color.mainOrangeColor)])
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if direction == .rightToLeft, index == 0 {

        }
        return true
    }
}
