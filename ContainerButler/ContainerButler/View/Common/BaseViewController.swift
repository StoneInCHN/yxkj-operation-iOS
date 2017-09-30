//
//  BaseViewController.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/11.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy  var backBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.setBackgroundImage(UIImage(named: "login_back"), for: .normal)
        return loginBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackBarButton()
    }
    
    deinit {
        debugPrint("ViewController deinit")
    }
    func setBackBarButton() {
        let image = UIImage(named: "new_nav_arrow_white")
        navigationController?.navigationBar.backIndicatorImage = image
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = image
        let backBarItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarItem
        automaticallyAdjustsScrollViewInsets = false
         view.backgroundColor = .white
    }
    
    func whenHiddenNavigationBarSetupBackBtn() {
         navigationController?.setNavigationBarHidden(true, animated: true)
         view.addSubview(backBtn)
        backBtn.rx.tap.subscribe(onNext: {[weak self]_ in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        backBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(13)
            maker.top.equalTo(28 + 10)
        }
    }
}
