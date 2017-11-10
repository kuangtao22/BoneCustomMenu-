//
//  BoneCustomFiltersView.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/8.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneCustomFiltersView: UIView {

    var fontColor = UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
    
    var selectColor = UIColor(red: 0/255, green: 139/255, blue: 254/255, alpha: 1)
    
    var sectionColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
    
    var line = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
    
    var setHeight: CGFloat? {
        didSet {
            guard let height = self.setHeight else {
                return
            }
            self.frame.size.height = height
            self.cleanBtn.frame.origin.y = self.frame.height - self.cleanBtn.frame.height
            self.confirmBtn.frame.origin.y = self.frame.height - self.confirmBtn.frame.height
            self.collectionView.frame.size.height = self.frame.height - self.cleanBtn.frame.height
        }
    }
    
    var delegate: BoneCustomDelegate? {
        didSet {
            self.dataSource.delegate = self.delegate
        }
    }

    fileprivate var dataSource = BoneFilterDataSource()
    fileprivate var collectionView: UICollectionView!
    fileprivate var layout = BoneFilterLayout()
    fileprivate let identifier = "BoneDayCell"
    fileprivate let headerIdentifier = "headerIdentifier"
    fileprivate let footerIdentifier = "footerIdentifier"

    fileprivate var cleanBtn: UIButton!     // 清除按钮
    fileprivate var confirmBtn: UIButton!   // 确认按钮
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.cleanBtn = self.getFootBtn(left: 0)
        self.cleanBtn.setTitle("清除", for: UIControlState.normal)
        self.cleanBtn.backgroundColor = UIColor.white
        self.cleanBtn.setTitleColor(self.fontColor, for: UIControlState.normal)
        self.cleanBtn.layer.borderWidth = 0.5
        self.cleanBtn.addTarget(self, action: #selector(self.cleanAction), for: UIControlEvents.touchUpInside)
        self.cleanBtn.layer.borderColor = self.line.cgColor
        self.addSubview(self.cleanBtn)
        
        self.confirmBtn = self.getFootBtn(left: self.frame.width / 2)
        self.confirmBtn.setTitle("确认", for: UIControlState.normal)
        self.confirmBtn.backgroundColor = self.selectColor
        self.confirmBtn.addTarget(self, action: #selector(self.confirmAction), for: UIControlEvents.touchUpInside)
        self.addSubview(self.confirmBtn)
        
        let size = CGSize(width: self.frame.width, height: self.frame.height - self.cleanBtn.frame.height)
        self.collectionView = UICollectionView(
            frame: CGRect(origin: CGPoint.zero, size: size),
            collectionViewLayout: self.layout
        )
        self.collectionView.allowsSelection = true          // 允许用户选择
        self.collectionView.allowsMultipleSelection = true  // 允许用户多选
        
        self.collectionView.backgroundColor = self.sectionColor
        // 水平居中collectionView两边
        self.collectionView.contentInset.left = 0
        self.collectionView.contentInset.right = 0
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.register(BoneFilterCollectionCell.self, forCellWithReuseIdentifier: self.identifier)
        self.collectionView.register(
            BoneFilterReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: self.headerIdentifier
        )
        self.collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionElementKindSectionFooter,
            withReuseIdentifier: self.footerIdentifier
        )
        self.addSubview(self.collectionView)
        
        self.dataSource.delegate = self.delegate
    }
    
    /// 获取底部按钮样式
    private func getFootBtn(left: CGFloat) -> UIButton {
        let button = UIButton(frame: CGRect(x: left, y: self.frame.height - 45, width: self.frame.width / 2, height: 45))
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        return button
    }
    
    /// 清除事件
    @objc private func cleanAction() {
        self.dataSource.cleanData()
        self.collectionView.reloadData()
    }
    
    
    /// 确认事件
    @objc private func confirmAction() {
        self.dataSource.submitData()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension BoneCustomFiltersView: BoneCustomMenuProtocol {
    
    func reloadData() {
        self.dataSource.initData()

        self.cleanBtn.setTitleColor(self.fontColor, for: UIControlState.normal)
        self.confirmBtn.backgroundColor = self.selectColor
        self.collectionView.reloadData()
    }
}

extension BoneCustomFiltersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.dataSource.sectionNum
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.rowNum(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.identifier, for: indexPath) as? BoneFilterCollectionCell
        let selectIcon = UIImage(named: "BoneCustomIcon.bundle/select")?.color(self.selectColor)
        cell?.button.setImage(selectIcon, for: UIControlState.selected)
        cell?.button.lineColor = self.line
        cell?.button.selectColor = self.selectColor
        cell?.button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.button.setTitleColor(self.fontColor, for: UIControlState.normal)
        cell?.button.setTitleColor(self.selectColor, for: UIControlState.selected)
        cell?.button.setTitle(self.dataSource.getSubTitle(indexPath), for: UIControlState.normal)
        cell?.button.isSelected = self.dataSource.getSelectState(indexPath)
        return cell!
    }
    
    
    
    // 返回headView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 40)
    }
    
    // 返回footview的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
    
    // 返回headView/footview样式
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerIdentifier, for: indexPath) as! BoneFilterReusableView
            reusableView.label.text = self.dataSource.getTitle(indexPath.section)
            return reusableView
            
        } else {
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.footerIdentifier, for: indexPath)
            return reusableView
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataSource.updata(indexPath)
        self.collectionView.reloadData()
    }

    
}

