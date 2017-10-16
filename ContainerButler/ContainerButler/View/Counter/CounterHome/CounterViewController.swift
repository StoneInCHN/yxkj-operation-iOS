//
//  CounterViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CounterViewController: BaseViewController {
    lazy var replenishmentView: ReplenishmentView = {
        let animator = ReplenishmentView()
        animator.replenishAction = { [weak self] in
            self?.navigationController?.pushViewController(ContainerManageVC(), animated: true)
        }
        return animator
    }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.allowsSelection = false
        taleView.register(CounterTableViewCell.self, forCellReuseIdentifier: "CounterTableViewCell")
        taleView.register(CounterSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "CounterSectionHeaderView")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
}

extension CounterViewController {
    fileprivate func setupUI() {
        title = "货柜"
        view.addSubview(tableView)
        replenishmentView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        view.addSubview(replenishmentView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
        let addBtn = UIButton(type: .contactAdd)
        addBtn.frame = CGRect(x: UIScreen.width - 44, y: 20, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addBtn)
        addBtn.rx.tap.subscribe(onNext: { [weak self] in
            let point = CGPoint(x:  UIScreen.width - 44 + 12, y: 12 + 44)
            YBPopupMenu.show(at: point, titles: ["待补清单", "补货记录"],
                             icons: nil,
                             menuWidth: 92) { menu in
                menu?.arrowDirection = .top
                menu?.rectCorner = UIRectCorner.bottomRight
                menu?.delegate = self
            }
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func setupRX() {
     tableView.dataSource = self
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension CounterViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CounterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.itemdidSelected = { [weak self] model in
            guard let weakSelf = self else { return }
            HUD.showAlert(from: weakSelf, title: "花样年华T3优享空间", message: "对A货柜进行补货\n补货时，货柜将暂停服务", enterTitle: "取消", cancleTitle: "开始补货", enterAction: nil, cancleAction: {
                weakSelf.navigationController?.pushViewController(ContainerManageVC(), animated: true)
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
}
extension CounterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: CounterSectionHeaderView = tableView.dequeueReusableHeaderFooter()
        headerView.listTapAction = {
            
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
}

extension CounterViewController: YBPopupMenuDelegate {
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {
        switch index {
        case 0: /// 待补清单
            navigationController?.pushViewController(NotReplenishedGoodsListVC(), animated: true)
        case 1: /// 补货记录
            navigationController?.pushViewController(ReplenishHistoryVC(), animated: true)
        default:
            break
        }
    }
}
