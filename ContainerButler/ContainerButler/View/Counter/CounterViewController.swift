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
        taleView.register(CounterTableViewCell.self, forCellReuseIdentifier: "CounterTableViewCell")
        taleView.register(CounterSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "CounterSectionHeaderView")
        return taleView
    }()
  var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
    
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
        
        let dataSource = self.dataSource
        
        let items = Variable<[SectionModel<String, Double>]>([])
        
        items.value = [
            SectionModel(model: "First section", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Second section", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Third section", items: [
                1.0,
                2.0,
                3.0
                ])
        ]
        
        dataSource.configureCell = { [unowned  self](_, tableView, indexPath, element) in
            let cell: CounterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.itemdidSelected
                .subscribe(onNext: {[weak self] (model) in
                    guard let weakSelf = self else { return }
                    weakSelf.replenishmentView.show()
            }).disposed(by: self.disposeBag)
            return cell
        }
        
        items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected
            .map { indexPath in
                return (indexPath, dataSource[indexPath])
            }
            .subscribe(onNext: { indexPath, model in
                
            })
            .disposed(by: disposeBag)
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
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
        return 50
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
