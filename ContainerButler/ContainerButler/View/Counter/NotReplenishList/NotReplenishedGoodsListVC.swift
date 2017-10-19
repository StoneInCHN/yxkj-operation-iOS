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

class NotReplenishedGoodsListVC: BaseViewController {
    fileprivate lazy  var addressLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.sizeToFit(with: 14)
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.numberOfLines = 0
        descLabel.text = "A货柜"
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
        animator.replenishAction = { [weak self] in
            
        }
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
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        loginBtn.setTitle("完成取货", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        loginBtn.layer.cornerRadius = 17.5
        loginBtn.layer.masksToBounds = true
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
        pageTitleView.setTitles(["全部", "水果牛奶", " 饼干蛋糕", "全部", "水果牛奶", " 饼干蛋糕"])
        let line = UIView()
        line.backgroundColor = UIColor(hex: 0xcccccc)
        pageTitleView.addSubview(line)
         pageTitleView.backgroundColor = .white
         view.addSubview(doneBtn)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        notreplenishmentView.frame = CGRect(x: 0, y: -UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        view.addSubview(notreplenishmentView)
        optiontableView.frame = CGRect(x: 0, y: -(view.bounds.height - 45), width: UIScreen.width, height: view.bounds.height - 45)
        view.insertSubview(optiontableView, aboveSubview: tableView)
        
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
        line.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(0.5)
        }
        doneBtn.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(150)
            $0.height.equalTo(36)
            $0.bottom.equalTo(-36)
        }
        tableView.snp.makeConstraints { (maker) in
             maker.top.equalTo(pageTitleView.snp.bottom)
             maker.left.right.equalTo(0)
             maker.bottom.equalTo(doneBtn.snp.top).offset(-20)
        }
    }
    
    fileprivate func setupRX() {
        chooseBtn.rx.tap
            .subscribe(onNext: {[weak self] _ in
            self?.showOptionChooseView()
        })
        .disposed(by: disposeBag)
        
        let items = Observable.just(
            (0..<20).map { "\($0)" }
        )
        
        items
            .bind(to: optiontableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.font = UIFont.sizeToFit(with: 13.5)
                cell.textLabel?.textColor = UIColor(hex: 0x333333)
                cell.textLabel?.text = "香年广场T2"
            }
            .disposed(by: disposeBag)
        
        optiontableView.rx
            .modelSelected(String.self)
            .subscribe(onNext: {[weak self] value in
                self?.hideOptionChooseView()
            })
            .disposed(by: disposeBag)
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
         notreplenishmentView.show()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
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
}
