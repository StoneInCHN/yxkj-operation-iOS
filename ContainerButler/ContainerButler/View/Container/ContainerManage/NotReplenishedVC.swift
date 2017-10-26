//
//  NotReplenishedVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//  货柜待补商品

import UIKit
import RxSwift
import RxCocoa
import MGSwipeTableCell
import MJRefresh

class NotReplenishedVC: BaseViewController {
    var containerId: Int = 0
    fileprivate lazy var listVM: ContainerManageViewModel = {[unowned self] in
        let viewModel =  ContainerManageViewModel()
        viewModel.param.cntrId = self.containerId
        viewModel.requestWaitSupplyContainerGoodsList()
        return viewModel
    }()
    
   fileprivate lazy var replenishManageView: ReplenishManageView = {
        let animator = ReplenishManageView()
        return animator
    }()
    fileprivate lazy var replenishDoneView: ReplenishedDoneView = {
        let animator = ReplenishedDoneView()
        return animator
    }()
    fileprivate lazy var tableView: UITableView = {
        let taleView = UITableView()
        taleView.separatorStyle = .none
        taleView.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        taleView.register(GoodListCell.self, forCellReuseIdentifier: "GoodListCell")
        return taleView
    }()
    
    fileprivate lazy  var doneBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        loginBtn.setTitle("拍照完成", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainGreenColor)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        return loginBtn
    }()
    fileprivate lazy  var stopBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        loginBtn.setTitle("暂停补货", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        loginBtn.layer.cornerRadius = 20
        loginBtn.layer.masksToBounds = true
        return loginBtn
    }()
    fileprivate lazy  var descPwdLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: CGFloat(12))
        descLabel.textColor = UIColor(hex: 0x333333)
        descLabel.textAlignment = .center
        descLabel.text = "* 若完成了整个货柜的补货，需要拍照记录"
        descLabel.numberOfLines = 0
        return descLabel
    }()
    
    fileprivate lazy  var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        return view
    }()
    fileprivate lazy var pictureOptionView: PictureChooseOptionView = {[unowned self] in
        let view = PictureChooseOptionView(frame: CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: UIScreen.height ))
        return view
    }()
    lazy  var cover: UIButton = {
        let cover = UIButton()
        cover.frame = UIScreen.main.bounds
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return cover
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
  
    override func viewWillAppear(_ animated: Bool) {
        if listVM.models.value.isEmpty {
            HUD.showLoading()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension NotReplenishedVC {
    fileprivate func setupUI() {
        view.addSubview(tableView)
        view.addSubview(containerView)
        containerView.addSubview(doneBtn)
        containerView.addSubview(stopBtn)
        containerView.addSubview(descPwdLabel)
        tableView.dataSource = self
        tableView.delegate = self
        containerView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalTo(0)
            maker.height.equalTo(100.0.fitHeight)
        }
        descPwdLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView.snp.centerX)
            maker.bottom.equalTo(containerView.snp.bottom).offset(-12)
        }
        stopBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView.snp.centerX).offset(70)
            maker.bottom.equalTo(descPwdLabel.snp.top).offset(-16.0.fitHeight)
            maker.width.equalTo(100.0.fitWidth)
            maker.height.equalTo(40)
        }
        doneBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView.snp.centerX).offset(-70)
            maker.top.equalTo(stopBtn.snp.top)
            maker.width.equalTo(100.0.fitWidth)
            maker.height.equalTo(40)
        }
        tableView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(containerView.snp.top).offset(-12)
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        replenishManageView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        replenishDoneView.frame = CGRect(x: 0, y: UIScreen.height, width: UIScreen.width, height: UIScreen.height)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(replenishManageView)
        UIApplication.shared.keyWindow?.addSubview(replenishDoneView)
        view.backgroundColor = UIColor(hex: CustomKey.Color.mainBackgroundColor)
        UIApplication.shared.keyWindow?.addSubview(pictureOptionView)
        pictureOptionView.cameraBtn.rx.tap
            .subscribe(onNext: { [weak self]_ in
                 self?.dismissPictureOptionView()
                self?.openMedia(.camera)
            })
        .disposed(by: disposeBag)

        pictureOptionView.photoBtn.rx.tap
            .subscribe(onNext: { [weak self]_ in
                self?.dismissPictureOptionView()
                self?.openMedia(.photoLibrary)
            })
            .disposed(by: disposeBag)

        pictureOptionView.cancleBtn.rx.tap
            .subscribe(onNext: { [weak self]_ in
                self?.dismissPictureOptionView()
            })
            .disposed(by: disposeBag)
        
        doneBtn.rx.tap
            .subscribe(onNext: { [weak self]_ in
                self?.doneAction()
            })
            .disposed(by: disposeBag)
        
        stopBtn.rx.tap
            .subscribe(onNext: { [weak self]_ in
                 self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        replenishDoneView.closeBtn.rx.tap
            .subscribe(onNext: { [weak self]_ in
                self?.replenishDoneView.dismiss()
            }).disposed(by: disposeBag)
        
        replenishDoneView.rechooseBtn.rx.tap
            .subscribe(onNext: { [weak self]_ in
                 self?.replenishDoneView.dismiss()
                self?.openMedia(.camera)
            }).disposed(by: disposeBag)
        
        replenishDoneView.doneBtn.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.replenishDoneView.dismiss()
                self?.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: disposeBag)
        
        listVM.models.asObservable().subscribe(onNext: { [weak self](_) in
            HUD.hideLoading()
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
        listVM.requestCommand.onNext(true)
    }
}

extension NotReplenishedVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
         replenishManageView.replenishAction = { [weak self] in
            self?.tableView.reloadData()
        }
        replenishManageView.config(listVM.models.value[indexPath.row])
        replenishManageView.show()
    }
    
}

extension NotReplenishedVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVM.models.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.delegate = self
        cell.configContainerWaitSupplyGoods(listVM.models.value[indexPath.row])
        return cell
    }
}

extension NotReplenishedVC: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        guard let cell = cell as? GoodListCell, let indexPath = tableView.indexPath(for: cell)  else {
            return nil
        }
        if direction == .rightToLeft {
            swipeSettings.transition = .border
            return  UIButton.createButtons(with: ["取消完成"], backgroudColors: [UIColor(hex: CustomKey.Color.mainOrangeColor)])
        }
        return nil
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        guard  let indexPath = tableView.indexPath(for: cell) else { return true    }
        if direction == .rightToLeft && index == 0 {
            tableView.reloadData()
        }
        return true
    }
}
extension NotReplenishedVC {
    fileprivate func doneAction() {
        UIApplication.shared.keyWindow?.insertSubview(cover, belowSubview: pictureOptionView)
        UIView.animate(withDuration: 0.25, animations: {[unowned self] in
            self.containerView.snp.updateConstraints {
                $0.bottom.equalTo(180)
            }
        }) { (_) in
            UIView.animate(withDuration: 0.25, animations: {[unowned self] in
                self.pictureOptionView.transform = CGAffineTransform(translationX: 0, y: -UIScreen.height)
            })
        }
        
    }
  
    fileprivate func dismissPictureOptionView() {
        UIView.animate(withDuration: 0.25, animations: { [unowned self] in
            self.pictureOptionView.transform = .identity
            self.cover.removeFromSuperview()
        }) { (_) in
            self.containerView.snp.updateConstraints {
                $0.bottom.equalTo(0)
            }
        }
    }
    
    fileprivate func openMedia(_ type: UIImagePickerControllerSourceType) {
       
        if !UIImagePickerController.isSourceTypeAvailable(type) {
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension NotReplenishedVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imge = info[UIImagePickerControllerOriginalImage] as? UIImage
        replenishDoneView.imageView.image = imge
        replenishDoneView.show()
        dismiss(animated: true, completion: nil)
    }
}
