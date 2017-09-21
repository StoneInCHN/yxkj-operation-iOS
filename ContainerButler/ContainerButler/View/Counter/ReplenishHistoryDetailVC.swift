//
//  ReplenishHistoryDetailVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ReplenishHistoryDetailVC: BaseViewController {
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
         taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
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

extension ReplenishHistoryDetailVC {
    fileprivate func setupUI() {
        title = "香年广场-编号:01"
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {
        let dataSource = self.dataSource
        let items = Variable<[SectionModel<String, Double>]>([])
        
        items.value = [
            SectionModel(model: "货道A", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "货道A", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "货道A", items: [
                1.0,
                2.0,
                3.0
                ])
        ]
        
        dataSource.configureCell = { [unowned  self](_, tableView, indexPath, element) in
            let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource[index].model
        }
        
        items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ReplenishHistoryDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
