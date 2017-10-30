//
//  WholeGoodsVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  全部商品

import UIKit
import RxSwift
import RxCocoa
import MGSwipeTableCell
import MJRefresh

class WholeGoodsVC: BaseViewController {
      var containerId: Int = 0
     fileprivate lazy var listVM: ContainerManageViewModel = {[unowned self] in
        let viewModel =  ContainerManageViewModel()
        viewModel.param.cntrId = self.containerId
        viewModel.requestAllGoods()
        return viewModel
        }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        return taleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }
    
}

extension WholeGoodsVC {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
         tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    fileprivate func setupRX() {
        let items = listVM.models.asObservable()
        items
            .bind(to: tableView.rx.items(cellIdentifier: "GoodListCell", cellType: GoodListCell.self)) {[weak self] (row, element, cell) in
                if let weakSelf = self {
                    cell.delegate = weakSelf
                    cell.configContainerWaitSupplyGoods(element)
                    cell.hiddenCover()
                }
            }
            .disposed(by: disposeBag)
        
        listVM.refreshStatus.asObservable().subscribe(onNext: {[weak self] (status) in
            switch status {
            case .beingFooterRefresh:
                self?.tableView.mj_footer.beginRefreshing()
            case .endFooterRefresh:
                self?.tableView.mj_footer.endRefreshing()
            case .noMoreData:
                self?.tableView.mj_footer.endRefreshingWithNoMoreData()
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {[weak self] in
            if let weakSelf = self {
                weakSelf.listVM.requestCommand.onNext(false)
            }
        })
        listVM.requestCommand.onNext(true)
    }
}

extension WholeGoodsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}
extension WholeGoodsVC: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        swipeSettings.transition = .border
        return  UIButton.createButtons(with: ["出货测试"], backgroudColors: [UIColor(hex: CustomKey.Color.mainOrangeColor)])
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if direction == .rightToLeft, index == 0 {

        }
        return true
    }
}
