//
//  ContainerManageVC.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/21.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa

class ContainerManageVC: BaseViewController {
    fileprivate lazy var pageTitleView: PageTitleView = {
        let pvc = PageTitleView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44), titles: ["待补商品", "全部商品"])
        return pvc
    }()
    fileprivate lazy var pageContenView: PageContentView  = { [unowned self] in
        var childVCs = [UIViewController]()
        let notReplenishVC = NotReplenishedVC()
        let wholeGoodsVC = WholeGoodsVC()
        childVCs.append(notReplenishVC)
        childVCs.append(wholeGoodsVC)
        let pageContenView = PageContentView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 44), childVCs: childVCs, parentVC: self)
        pageContenView.collectView.isScrollEnabled = false
        return pageContenView
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tapAction()
    }
}

extension ContainerManageVC {
    private  func setupUI() {
        automaticallyAdjustsScrollViewInsets = false
        title = "A货柜管理"
        view.addSubview(pageTitleView)
        view.addSubview(pageContenView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "拍照完成", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
            
        })
            .disposed(by: disposeBag)
    }
    
    private  func tapAction() {
        pageTitleView.titleTapAction = {[weak self] seletedIndex in
            self?.pageContenView.selected(index: seletedIndex)
        }
        pageContenView.tapAction = {[weak self] (progress, souceIndex, targetIndex) in
            self?.pageTitleView.setTitle(progress: progress, sourceIndex: souceIndex, targetIndex: targetIndex)
        }
    }
}
