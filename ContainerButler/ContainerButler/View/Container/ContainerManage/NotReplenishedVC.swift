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
import Closures

class NotReplenishedVC: BaseViewController {
    var containerId: Int = 0
    var currentScence: Scence?
    fileprivate lazy var listVM: ContainerManageViewModel = {[unowned self] in
        let viewModel =  ContainerManageViewModel()
        viewModel.param.cntrId = self.containerId
        viewModel.requestWaitSupplyContainerGoodsList()
        viewModel.loadSelectedContainerGoods()
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
        loginBtn.setTitleColor(UIColor.gray, for: .disabled)
        loginBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainGreenColor)
        loginBtn.layer.cornerRadius = 20.0.fitHeight
        loginBtn.layer.masksToBounds = true
        return loginBtn
    }()
    fileprivate lazy  var stopBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.titleLabel?.font = UIFont.sizeToFit(with: 13)
        loginBtn.setTitle("暂停补货", for: .normal)
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        loginBtn.setTitleColor(UIColor.gray, for: .highlighted)
        loginBtn.setTitleColor(UIColor.gray, for: .disabled)
        loginBtn.backgroundColor = UIColor(hex: CustomKey.Color.mainOrangeColor)
        loginBtn.layer.cornerRadius = 20.0.fitHeight
        loginBtn.layer.masksToBounds = true
        loginBtn.isEnabled = true
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
        view.backgroundColor = UIColor.white
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
            maker.height.equalTo(40.0.fitHeight)
        }
        doneBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(containerView.snp.centerX).offset(-70)
            maker.top.equalTo(stopBtn.snp.top)
            maker.width.equalTo(100.0.fitWidth)
            maker.height.equalTo(40.0.fitHeight)
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
        
        stopBtn.onTap { [weak self] in
            guard let weakSelf = self else {
                return
            }
            weakSelf.commitSupplyRecord()
                .subscribe(onNext: { (response) in
                    HUD.showSuccess(response.description ?? "")
                    weakSelf.navigationController?.popToRootViewController(animated: true)
                }, onError: { (error) in
                    if let error = error as? AppError {
                        HUD.showError(error.message)
                    }
                }).disposed(by: weakSelf.disposeBag)
        }
        
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
                guard let weakSelf = self else {    return  }
                weakSelf.replenishDoneView.dismiss()
                HUD.showLoading()
                Observable.combineLatest(weakSelf.commitSupplyRecord(), weakSelf.uploadPic(), resultSelector: { (obj1, obj2) -> Bool in
                    if obj1.status == .success && obj2.status == .success {
                        return true
                    }
                    return false
                }).subscribe(onNext: { (isSuccess) in
                    if isSuccess {
                        HUD.showSuccess("提交成功")
                        weakSelf.navigationController?.popToRootViewController(animated: true)
                    } else {
                         HUD.showError("提交失败")
                    }
                }, onError: { (error) in
                    HUD.showError(error.localizedDescription)
                }).disposed(by: weakSelf.disposeBag)
                }, onCompleted: {
                    HUD.hideLoading()
            }).disposed(by: disposeBag)
        
        listVM.models.asObservable().subscribe(onNext: { [weak self](_) in
            HUD.hideLoading()
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        listVM.selectedContainerModels
            .asObservable()
            .map {!$0.isEmpty}
            .bind(to: stopBtn.rx.isEnabled)
            .disposed(by: disposeBag)
        
        listVM.selectedContainerModels
            .asObservable()
            .map {!$0.isEmpty}
            .bind(to: doneBtn.rx.isEnabled)
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

extension NotReplenishedVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            replenishManageView.replenishAction = { [weak self] inputCount in
                guard let weakSelf = self else {
                    return
                }
                if indexPath.row < weakSelf.listVM.models.value.count {
                    let selectedModel = weakSelf.listVM.models.value[indexPath.row]
                    selectedModel.waitSupplyCount = selectedModel.waitSupplyCount - inputCount
                    selectedModel.supplyCount  = inputCount
                    weakSelf.listVM.models.value.remove(at: indexPath.row)
                    weakSelf.listVM.cacheSelectedContainerGoods(selectedModel)
                    weakSelf.tableView.reloadData()
                }
                
            }
            replenishManageView.config(listVM.models.value[indexPath.row])
            replenishManageView.show()
        }
    }
    
}

extension NotReplenishedVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listVM .models.value.count
        } else {
            return listVM .selectedContainerModels.value.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GoodListCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        if indexPath.section == 0 {
            cell.configContainerWaitSupplyGoods(listVM.models.value[indexPath.row])
            cell.hiddenCover()
            return cell
        } else {
            cell.delegate = self
            cell.configContainerWaitSupplyGoods(listVM.selectedContainerModels.value[indexPath.row])
            cell.showCover(listVM.selectedContainerModels.value[indexPath.row].waitSupplyCount)
        }
        return cell
    }
}

extension NotReplenishedVC: MGSwipeTableCellDelegate {
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        guard let cell = cell as? GoodListCell, let indexPath = tableView.indexPath(for: cell)  else {
            return nil
        }
        if indexPath.section == 1, direction == .rightToLeft {
            swipeSettings.transition = .border
            return  UIButton.createButtons(with: ["取消完成"], backgroudColors: [UIColor(hex: CustomKey.Color.mainOrangeColor)])
        }
        return nil
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, tappedButtonAt index: Int, direction: MGSwipeDirection, fromExpansion: Bool) -> Bool {
        if  let indexPath = tableView.indexPath(for: cell), indexPath.section == 1, direction == .rightToLeft, index == 0 {
            let selectedModel = listVM.selectedContainerModels.value[indexPath.row]
            listVM.resetData(selectedModel, index: indexPath.row)
            tableView.reloadData()
        }
        return true
    }
}
extension NotReplenishedVC {
    fileprivate func commitSupplyRecord() -> Observable<NullDataResponse> {
        let param = ContainerSessionParam()
        param.sceneSn = currentScence?.number
        var recordsArray = [SuplementRecordParam]()
        let selectedArray = listVM.selectedContainerModels.value
        for selectedGoods in selectedArray {
            let suppplyParam = SuplementRecordParam()
            suppplyParam.supplementId = selectedGoods.supplementId
            suppplyParam.supplyCount = selectedGoods.supplyCount
            recordsArray.append(suppplyParam)
        }
        param.suplementRecords = recordsArray
        return  listVM.requestSupplementRecord(param)
    }
    
    fileprivate func uploadPic() -> Observable<NullDataResponse> {
        let param = ContainerSessionParam()
        param.cntrId = containerId
        if let image = replenishDoneView.imageView.image,
            let data = UIImageJPEGRepresentation(image, 0.01) {
            return  listVM.uploadSupplementPicture(param, file: data)
        }
        return Observable.of(NullDataResponse(JSON: [:])!)
    }
    
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
