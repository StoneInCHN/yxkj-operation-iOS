//
//  CounterTableViewCell.swift
//  ContainerButler
//
//  Created by lieon on 2017/9/19.
//  Copyright © 2017年 QuanChengShouWei. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CounterTableViewCell: UITableViewCell, ViewNameReusable {
    let disposeBag: DisposeBag = DisposeBag()
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.randomColor
        descLabel.numberOfLines = 0
        descLabel.text = "1组"
        return descLabel
    }()
    
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.randomColor
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.register(CounterCollectionCell.self, forCellWithReuseIdentifier: "CounterCollectionCell")
        return collectionView
        }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(numberLabel)
         contentView.addSubview(collectionView)
        
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(12)
            maker.top.equalTo(12)
            maker.height.equalTo(30)
        }
        collectionView.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.top.equalTo(numberLabel.snp.bottom).offset(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
        }
        let items = Observable.just(
            (0..<6).map { "\($0)" }
        )
        items
            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                let cell: CounterCollectionCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
                cell.config(element)
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let minimumInteritemSpacing: CGFloat = 12
        let minimumLineSpacing: CGFloat = 12
        let leftInset: CGFloat = 12
        let rightInset: CGFloat = 12
        let topInset: CGFloat = 12
        let bottomInset: CGFloat = 12
        let maxYofNameLabel: CGFloat = 12 + 30
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: topInset,
                                                          left: leftInset,
                                                          bottom: bottomInset,
                                                          right: rightInset)
        layout.itemSize = CGSize(
            width: (bounds.width - minimumInteritemSpacing * 3 - leftInset * 2) / 4,
            height: (bounds.height - maxYofNameLabel - minimumLineSpacing - topInset * 2) / 2
        )
        collectionView.collectionViewLayout = layout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class CounterCollectionCell: UICollectionViewCell, ViewNameReusable {
    
    fileprivate lazy  var numberLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor(hex: 0x808080)
        descLabel.numberOfLines = 0
        return descLabel
    }()
    fileprivate lazy var badgeView: GIBadgeView = {
        let badgeView = GIBadgeView()
        badgeView.badgeValue = 5
        return badgeView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .yellow
        numberLabel.backgroundColor =  UIColor.randomColor
        contentView.addSubview(numberLabel)
        numberLabel.addSubview(badgeView)
        numberLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.top.equalTo(0)
        }
    }
    
    func config(_ text: String) {
        numberLabel.text = text
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
