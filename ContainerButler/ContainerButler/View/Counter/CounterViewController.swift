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
        
        dataSource.configureCell = { (_, tableView, indexPath, element) in
            let cell: CounterTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
//            cell.textLabel?.text = "\(element) @ row \(indexPath.row)"
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
