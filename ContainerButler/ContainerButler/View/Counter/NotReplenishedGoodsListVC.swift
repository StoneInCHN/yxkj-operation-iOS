//
//  NotReplenishedGoodsListVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  待补清单

import UIKit

class NotReplenishedGoodsListVC: BaseViewController {
    lazy var notreplenishmentView: NotReplenishView = {
        let animator = NotReplenishView()
        animator.replenishAction = { [weak self] in
            self?.navigationController?.pushViewController(ContainerManageVC(), animated: true)
        }
        return animator
    }()
    
    fileprivate lazy var pageTitleView: PageTitleView = {
        let pvc = PageTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44), titles: nil)
        pvc.labelCountPerPage =  5
        return pvc
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.backgroundColor = UIColor(hex: 0xfafafa)
        taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension NotReplenishedGoodsListVC {
    fileprivate func setupUI() {
        let titleBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 30))
        titleBtn.setTitle("待补清单: 全部△", for: .normal)
        navigationItem.titleView = titleBtn
        titleBtn.rx.tap
            .subscribe(onNext: { [weak self] in
              let point = CGPoint(x:  UIScreen.width * 0.5 + titleBtn.bounds.width * 0.5, y: 12 + 44)
                self?.showPopMenu(position: point)
            }).disposed(by: disposeBag )
       
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成取货", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag )
        
         view.addSubview(pageTitleView)
        pageTitleView.setTitles(["全部", "水果牛奶", " 饼干蛋糕", "全部", "水果牛奶", " 饼干蛋糕"])
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { (maker) in
             maker.top.equalTo(44)
            maker.left.right.bottom.equalTo(0)
        }
        notreplenishmentView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        view.addSubview(notreplenishmentView)
    }
}
extension NotReplenishedGoodsListVC: YBPopupMenuDelegate {
    fileprivate func showPopMenu(position: CGPoint) {
        YBPopupMenu.show(at: position, titles: ["全部", "香年广场", "香年广场", "香年广场", "香年广场"],
                         icons: nil,
                         menuWidth: 92) { menu in
                            menu?.arrowDirection = .top
                            menu?.rectCorner = UIRectCorner.bottomRight
                            menu?.delegate = self
        }
    }
    
    func ybPopupMenuDidSelected(at index: Int, ybPopupMenu: YBPopupMenu!) {

    }
}

extension NotReplenishedGoodsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         notreplenishmentView.show()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension NotReplenishedGoodsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let unReadAction = UITableViewRowAction(style: .normal, title: "标记为未取货") { (_, indexPath) in
            
        }
        return [unReadAction]
    }
}
