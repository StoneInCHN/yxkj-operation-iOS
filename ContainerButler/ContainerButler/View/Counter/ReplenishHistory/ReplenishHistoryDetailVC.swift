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
         taleView.register(ReplenishHistoryDetailCell.self, forCellReuseIdentifier: "ReplenishHistoryDetailCell")
        taleView.register(ReplenishHistoryDetailTableHeader.self, forHeaderFooterViewReuseIdentifier: "ReplenishHistoryDetailTableHeader")
        return taleView
    }()
    
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
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>(configureCell: { [unowned  self](_, tableView, indexPath, element) in
            let cell: ReplenishHistoryDetailCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            debugPrint(self.description)
            return cell
        })
        
        items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ReplenishHistoryDetailVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ReplenishHistoryDetailTableHeader = tableView.dequeueReusableHeaderFooter()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
}
