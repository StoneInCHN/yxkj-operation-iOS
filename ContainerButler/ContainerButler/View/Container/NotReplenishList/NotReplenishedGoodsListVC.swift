//
//  NotReplenishedGoodsListVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  待补清单

import UIKit
import RxCocoa
import RxSwift
import pop
import MJRefresh
import MGSwipeTableCell

class NotReplenishedGoodsListVC: BaseViewController {
    fileprivate lazy var listVM: ContainerManageViewModel = ContainerManageViewModel()
    fileprivate lazy  var addressLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.sizeToFit(with: 14)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "全部"
        return descLabel
    }()
    
    fileprivate lazy  var chooseBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 12)
        loginBtn.setTitle("选择优享空间", for: .normal)
        loginBtn.setTitleColor(UIColor(hex: 0x666666), for: .normal)
        loginBtn.setTitleColor(UIColor(hex: CustomKey.Color.mainOrangeColor), for: .highlighted)
        return loginBtn
    }()
    
    fileprivate lazy   var triangleIcon: UIImageView = {
        let pwdLog = UIImageView(image: UIImage(named: "triangle"))
        pwdLog.contentMode = .center
        return pwdLog
    }()
    
    lazy var notreplenishmentView: NotReplenishView = {
        let animator = NotReplenishView()
        return animator
    }()
    
    fileprivate lazy var pageTitleView: PageTitleView = {
        let pvc = PageTitleView(frame: CGRect(x: 0, y: 45, width: UIScreen.main.bounds.width, height: 44), titles: nil)
        pvc.labelCountPerPage =  5
        return pvc
    }()
    
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.contentInset = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        return taleView
    }()
    
    fileprivate lazy var optiontableView: UITableView = {
        let taleView = UITableView()
        taleView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 65, right: 0)
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        return taleView
    }()
    fileprivate lazy  var doneBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setImage(UIImage(named: "complete_goods"), for: .normal)
        return loginBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRX()
    }

}

extension NotReplenishedGoodsListVC {
    fileprivate func setupUI() {
        title = "待补清单"
        let optionChooseView = UIView()
        optionChooseView.backgroundColor = .white
        optionChooseView.layer.borderWidth = 0.5
        optionChooseView.layer.borderColor = UIColor(hex: 0xcccccc).cgColor
        view.addSubview(optionChooseView)
        optionChooseView.addSubview(addressLabel)
        optionChooseView.addSubview(chooseBtn)
        optionChooseView.addSubview(triangleIcon)
        view.addSubview(pageTitleView)
        view.addSubview(tableView)
        view.addSubview(doneBtn)
    
         pageTitleView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        notreplenishmentView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
         UIApplication.shared.keyWindow?.addSubview(notreplenishmentView)
        optiontableView.frame = CGRect(x: 0, y: -(view.bounds.height - 45), width: UIScreen.width, height: view.bounds.height - 45)
        view.insertSubview(optiontableView, aboveSubview: doneBtn)
        
        optionChooseView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.height.equalTo(45)
        }
        addressLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(27)
            maker.centerY.equalTo(optionChooseView.snp.centerY)
        }
        triangleIcon.snp.makeConstraints { (maker) in
            maker.right.equalTo(-27)
            maker.centerY.equalTo(optionChooseView.snp.centerY)
        }
        chooseBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(triangleIcon.snp.left).offset(-17)
            maker.centerY.equalTo(optionChooseView.snp.centerY)
            maker.height.equalTo(36)
        }
        doneBtn.snp.makeConstraints {
            $0.right.equalTo(-15)
            $0.width.equalTo(48)
            $0.height.equalTo(48)
            $0.bottom.equalTo(-15)
        }
        tableView.snp.makeConstraints { (maker) in
             maker.top.equalTo(pageTitleView.snp.bottom)
             maker.left.right.equalTo(0)
             maker.bottom.equalTo(0)
        }
    }
    
    fileprivate func setupRX() {
        chooseBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in
            self?.showOptionChooseView()
        })
        .disposed(by: disposeBag)
      
       let items =  listVM.scenceList.asObservable()
        items
            .bind(to: optiontableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.font = UIFont.sizeToFit(with: 13.5)
                cell.textLabel?.textColor = UIColor(hex: 0x333333)
                cell.textLabel?.text = element.name
            }
            .disposed(by: disposeBag)
        
        optiontableView.rx
            .modelSelected(Scence.self)
            .subscribe(onNext: {[weak self] value in
                self?.addressLabel.text = value.name
                self?.hideOptionChooseView()
                guard let weakSelf = self else {
                    return
                }
                let selectedScence = value
                weakSelf.listVM.param.sceneSn = selectedScence.number
                weakSelf.listVM.requestCommand.onNext(true)
                weakSelf.listVM.refreshStatus.value = .endFooterRefresh
            })
            .disposed(by: disposeBag)
        
        listVM.goodsCategory.asObservable()
            .subscribe(onNext: {[weak self] (list) in
                var titles = [String]()
                for cate in list {
                    if let title = cate.cateName {
                        titles.append(title)
                    }
                }
                self?.pageTitleView.setTitles(titles)
                let line0 = UIView()
                line0.backgroundColor = UIColor(hex: 0xcccccc)
                line0.frame = CGRect(x: 0, y: 44 - 0.5, width: UIScreen.main.bounds.width, height: 0.5)
                if let weakSelf = self {
                    weakSelf.pageTitleView.addSubview(line0)
                }
            }).disposed(by: disposeBag)
        
        listVM.models.asObservable().subscribe(onNext: { [weak self](_) in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)

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
        pageTitleView.titleTapAction = {[weak self]index in
            guard let weakSelf = self else {
                return
            }
            let selectedCate = weakSelf.listVM.goodsCategory.value[index]
            weakSelf.listVM.param.cateId = selectedCate.cateId
            weakSelf.listVM.requestCommand.onNext(true)
             weakSelf.listVM.refreshStatus.value = .endFooterRefresh
        }
        listVM.requestCommand.onNext(true)
    }
    
    private func showOptionChooseView() {
        UIView.animate(withDuration: 0.25, animations: {   [unowned self] in
            let transform = CATransform3DMakeRotation(CGFloat(CFloat.pi), 0, 0, 1)
            self.triangleIcon.layer.transform = transform
            self.optiontableView.transform = CGAffineTransform(translationX: 0, y: (self.view.bounds.height + 45 + 20))
        })
    }
    
    fileprivate func hideOptionChooseView() {
        UIView.animate(withDuration: 0.25, animations: {   [unowned self] in
            self.triangleIcon.layer.transform = CATransform3DIdentity
            self.optiontableView.transform = .identity
            })
    }
}

extension NotReplenishedGoodsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let param = ContainerSessionParam()
        param.goodsSn = listVM.models.value[indexPath.row].goodsSn
        HUD.showLoading()
        listVM.requestWaitSupplyGoodsDetail(param)
            .subscribe(onNext: {[weak self] (detail) in
               self?.notreplenishmentView.config(detail)
               self?.notreplenishmentView.show()
            }, onError: { (error) in
                if let error = error as? AppError {
                    HUD.hideLoading()
                    HUD.showError(error.message)
                }
            }, onCompleted: {
                 HUD.hideLoading()
            })
        .disposed(by: disposeBag)
        notreplenishmentView.replenishAction = { [weak self] count in
            guard let weakSelf = self else {
                return
            }
            let selectedGoods = weakSelf.listVM.models.value[indexPath.row]
            selectedGoods.waitSupplyCount =  selectedGoods.waitSupplyCount - count
            selectedGoods.isSupplied = true
            weakSelf.listVM.models.value.remove(at: indexPath.row)
            weakSelf.listVM.models.value.append(selectedGoods)
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
}

extension NotReplenishedGoodsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVM.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        if indexPath.row < listVM.models.value.count {
            cell.configWaitSupplyGoods(listVM.models.value[indexPath.row])
        }
        let goods = listVM.models.value[indexPath.row]
        if goods.isSupplied {
            cell.showCover(goods.waitSupplyCount, text: "完成取货")
        } else {
            cell.hiddenCover()
        }
        return cell
    }
}

extension NotReplenishedGoodsListVC: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        guard let cell = cell as? GoodListCell, let indexPath = tableView.indexPath(for: cell)  else {
            return nil
        }
        if direction == .rightToLeft {
            let doneBtn = UIButton.createButtons(with: ["取消完成"], backgroudColors: [UIColor(hex: CustomKey.Color.mainOrangeColor)])
            doneBtn[0].rx.tap
                .subscribe(onNext: { [weak self] _ in
                    
                }).disposed(by: disposeBag)
            return doneBtn
        }
        return nil
    }
}
