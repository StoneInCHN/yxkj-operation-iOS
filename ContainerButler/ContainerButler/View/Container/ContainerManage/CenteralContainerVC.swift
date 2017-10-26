//
//  CenteralContainerVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/24.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Closures

class CenteralContainerVC: BaseViewController {
    fileprivate var centralViewModel: CentralContainerViewModel = CentralContainerViewModel()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorInset = UIEdgeInsets(top: 0, left: 100000, bottom: 0, right: 0)
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(VolumeTableViewCell.self, forCellReuseIdentifier: "VolumeTableViewCell")
        taleView.register(LabelButtonCell.self, forCellReuseIdentifier: "LabelButtonCell")
        return taleView
    }()
    let items = Variable([
        "音量",
        "货柜重启"
        ])
 
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension CenteralContainerVC {
    fileprivate func setupUI() {
        title = "中控管理"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
}

extension CenteralContainerVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = items.value[indexPath.row]
        if element == "音量" {
            let cell: VolumeTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.slider.onChange(handler: { value in
                print(value)
            })
            return cell
        }
        if element == "货柜重启" {
            let cell: LabelButtonCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.leftLabel.text = "货柜重启"
            cell.rightBtn.setTitle("重启", for: .normal)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            cell.rightBtn.onTap {
                print("--------")
            }
            return cell
        }
        return UITableViewCell()
    }
}
