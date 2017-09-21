//
//  ReplenishHistoryVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  补货记录

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ReplenishHistoryVC: BaseViewController {
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(ReplenishHistoryCell.self, forCellReuseIdentifier: "ReplenishHistoryCell")
        taleView.register(ReplenishHistoryTableHeader.self, forHeaderFooterViewReuseIdentifier: "ReplenishHistoryTableHeader")
        return taleView
    }()
    var dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
}

extension ReplenishHistoryVC {
     fileprivate func setupUI() {
        title = "补货记录"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
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
            let cell: ReplenishHistoryCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
        
        items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ReplenishHistoryVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ReplenishHistoryTableHeader = tableView.dequeueReusableHeaderFooter()
       
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
