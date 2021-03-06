//
//  BoneFilterCollectionCell.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2017/11/8.
//  Copyright © 2017年 鱼骨头. All rights reserved.
//

import UIKit

class BoneFilterCollectionCell: UICollectionViewCell {
    typealias Color = BoneCustomPopup.Color
    var button: FilterButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.button = FilterButton(frame: self.bounds)
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.button.isUserInteractionEnabled = false
        self.button.lineColor = Color.line
        self.button.selectColor = Color.select
        let selectIcon = UIImage(named: "BoneCustomIcon.bundle/select")?.color(Color.select)
        self.button.setImage(selectIcon, for: UIControlState.selected)
        self.button.setTitleColor(Color.font, for: UIControlState.normal)
        self.button.setTitleColor(Color.select, for: UIControlState.selected)
        self.contentView.addSubview(self.button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    class FilterButton: UIButton {
        var lineColor: UIColor = UIColor.black.withAlphaComponent(0.1)
        var selectColor: UIColor = UIColor.red
        
        override func draw(_ rect: CGRect) {
            let context = UIGraphicsGetCurrentContext()
            context?.addRect(rect)
            context?.setLineWidth(0.5)  // 线的size

            if self.isSelected {
                context?.setStrokeColor(Color.select.cgColor) // 颜色
                context?.setFillColor(Color.select.withAlphaComponent(0.03).cgColor)
            } else {
                context?.setStrokeColor(self.lineColor.cgColor) // 颜色
                context?.setFillColor(UIColor.white.cgColor)
            }
            
            context?.drawPath(using: CGPathDrawingMode.fillStroke)
            super.draw(rect)
        }
    }

}
