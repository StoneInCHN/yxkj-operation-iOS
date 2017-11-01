//
//  MineViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/10/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MineViewController: BaseViewController {
    fileprivate lazy var datas: [String] = ["用户", "密码"]
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(TitleLabelTableViewCell.self, forCellReuseIdentifier: "TitleLabelTableViewCell")
        taleView.register(UserHeaderCell.self, forCellReuseIdentifier: "UserHeaderCell")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
}

extension MineViewController {
    fileprivate func setupUI() {
        title = "我的"
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
    }
}

extension MineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = datas[indexPath.row]
        if  title == "用户" {
            let cell: UserHeaderCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.userLog.image = UIImage(named: "logo")
            cell.titleLabel.text = "用户: s12312312"
            return cell
        } else if title == "密码" {
            let cell: TitleLabelTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.titleLabel.text = "密码"
             return cell
        }
        return UITableViewCell()
    }
}

extension MineViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
        let title = datas[indexPath.row]
        if  title == "用户" {
            return
        } else if title == "密码" {
           navigationController?.pushViewController(UpdatePasswordVC(), animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = datas[indexPath.row]
        if  title == "用户" {
            return 88
        } else if title == "密码" {
            return 45
        }
        return 0
    }
}
