//
//  NotReplenishedVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  待补商品

import UIKit
import RxSwift
import RxCocoa
import MGSwipeTableCell

class NotReplenishedVC: BaseViewController {
    fileprivate lazy var datas: [Bool] = {
        let datas: [Bool] = [true, false, false, true, true, false, false, false, false, false]
        return datas
    }()
    lazy var replenishManageView: ReplenishManageView = {
        let animator = ReplenishManageView()
        return animator
    }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navi = navigationController as? NavigationController {
            navi.reomveBackGesture()
        }
    }
}

extension NotReplenishedVC {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(-64)
        }
        replenishManageView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        parent?.view.addSubview(replenishManageView)
    }
}

extension NotReplenishedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         replenishManageView.show()
         replenishManageView.replenishAction = { [weak self] in
            self?.datas[indexPath.row] = true
            tableView.reloadData()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension NotReplenishedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        if datas[indexPath.row] {
            cell.showCover(3)
        } else {
            cell.hiddenCover()
        }
        return cell
    }
}

extension NotReplenishedVC: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        guard let cell = cell as? GoodListCell, let indexPath = tableView.indexPath(for: cell)  else {
            return nil
        }
        if datas[indexPath.row], direction == .rightToLeft {
            swipeSettings.transition = .border
            return  createLeftButtons(with: ["取消完成"], backgroudColors: [UIColor(hex: CustomKey.Color.mainOrangeColor)])
        }
        return nil
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        guard  let indexPath = tableView.indexPath(for: cell) else { return true    }
        if direction == .rightToLeft && datas[indexPath.row] == true && index == 0 {
            datas[indexPath.row] = false
            tableView.reloadData()
        }
        return true
    }
}

extension NotReplenishedVC {
    fileprivate  func createLeftButtons(with titles: [String], backgroudColors: [UIColor]) -> [UIButton] {
        var buttons: [UIButton] = [UIButton]()
        if titles.count != backgroudColors.count {
            return buttons
        }
        for index in 0 ..< titles.count {
            let loginBtn = UIButton()
            loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
            loginBtn.setTitle(titles[index], for: .normal)
            loginBtn.setTitleColor(UIColor.white, for: .normal)
            loginBtn.backgroundColor = backgroudColors[index]
            loginBtn.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
            buttons.append(loginBtn)
        }
        return buttons
    }
}
