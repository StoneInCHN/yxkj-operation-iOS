//
//  ContainerViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import MJRefresh

class ContainerViewController: BaseViewController {
    fileprivate lazy var containerVM: ContainerViewModel = ContainerViewModel()
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
        taleView.allowsSelection = false
        taleView.register(ContainerTableViewCell.self, forCellReuseIdentifier: "ContainerTableViewCell")
        taleView.register(ContainerSectionHeaderView.self, forHeaderFooterViewReuseIdentifier: "ContainerSectionHeaderView")
        return taleView
    }()
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Container>>(
        configureCell: { (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "ContainerTableViewCell")!
            return cell
     }
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
        
        containerVM.refreshStatus.asObservable().subscribe(onNext: {[weak self] (status) in
            switch status {
            case .beingHeaderRefresh:
                self?.tableView.mj_header.beginRefreshing()
            case .endHeaderRefresh:
                self?.tableView.mj_header.endRefreshing()
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
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[unowned self] in
            self.containerVM.requestCommand.onNext(true)
        })
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.containerVM.requestCommand.onNext(false)
        })
        self.containerVM.requestCommand.onNext(true)
    }
}

extension ContainerViewController {
    fileprivate func setupUI() {
        title = "货柜"
        view.addSubview(tableView)
        replenishmentView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        view.addSubview(replenishmentView)
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.top.equalTo(0)
        }
        let addBtn = UIButton()
        addBtn.setImage(UIImage(named: "add"), for: .normal)
        addBtn.frame = CGRect(x: UIScreen.width - 44, y: 20, width: 44, height: 44)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addBtn)
        addBtn.rx.tap.subscribe(onNext: { [weak self] in
            let point = CGPoint(x:  UIScreen.width - 44 + 12, y: 12 + 44)
            YBPopupMenu.show(at: point, titles: ["待补清单", "补货记录"],
                             icons: ["pending_replenishment_list", "replenishment_record"],
                             menuWidth: 125) { menu in
                menu?.arrowDirection = .top
                menu?.rectCorner = UIRectCorner.bottomRight
                menu?.delegate = self
                menu?.backColor = UIColor(hex: 0x333333)
                menu?.textColor = UIColor.white
                menu?.fontSize = 13
            }
        })
        .disposed(by: disposeBag)
    }
    
    fileprivate func setupRX() {
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        let items = containerVM.models.asObservable()
        items
            .bind(to: tableView.rx.items(cellIdentifier: "ContainerTableViewCell", cellType: ContainerTableViewCell.self)) { [weak self] (row, element, cell) in
                cell.itemdidSelected = { [weak self] model in
                    guard let weakSelf = self else { return }
                    HUD.showAlert(from: weakSelf, title: "花样年华T3优享空间", message: "对A货柜进行补货\n补货时，货柜将暂停服务", enterTitle: "取消", cancleTitle: "开始补货", enterAction: nil, cancleAction: {
                        weakSelf.navigationController?.pushViewController(ContainerManageVC(), animated: true)
                    })
                }
            }
            .disposed(by: disposeBag)
    }
}

extension ContainerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: ContainerSectionHeaderView = tableView.dequeueReusableHeaderFooter()
        headerView.listTapAction = {
            
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section < containerVM.cellHeights.count {
            let cells = containerVM.cellHeights[indexPath.section]
            return cells[indexPath.row]
        }
       return 0.0
    }
}

extension ContainerViewController: YBPopupMenuDelegate {
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
