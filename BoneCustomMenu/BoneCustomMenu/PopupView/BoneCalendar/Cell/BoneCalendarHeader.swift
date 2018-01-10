
//
//  BoneCalendarHeader.swift
//  BoneCustomMenu
//
//  Created by 俞旭涛 on 2018/1/9.
//  Copyright © 2018年 鱼骨头. All rights reserved.
//

import UIKit

extension BoneCalendarHeader {
    
    func timeSelectAction(_ callback: @escaping touchUpInside) {
        self.onClick = callback
    }
    
    func reloadData() {
        self.button.backgroundColor = BoneCustomPopup.Color.select
    }
}
class BoneCalendarHeader: UIView {

    var text: String? {
        didSet {
            self.textLabel.text = self.text
        }
    }
    
    var isSelect: Bool {
        get {
            return self.button.isSelected
        }
    }
    
    typealias touchUpInside = (_ button: UIButton) -> Void
    fileprivate var onClick: touchUpInside?
    fileprivate var textLabel: UILabel!
    fileprivate var button: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        self.button = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 65, height: self.frame.height - 17)))
        self.button.center.y = self.center.y
        self.button.frame.origin.x = self.frame.width - self.button.frame.width - 15
        self.button.setTitle("选择时间", for: UIControlState.normal)
        self.button.setTitle("选择日期", for: UIControlState.selected)
        self.button.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        self.button.layer.masksToBounds = true
        self.button.layer.cornerRadius = self.button.frame.height / 2
        self.button.addTarget(self, action: #selector(self.timeAction), for: UIControlEvents.touchUpInside)
        self.addSubview(self.button)
        
        self.textLabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.button.frame.origin.x - 20, height: 40))
        self.textLabel.font = UIFont.systemFont(ofSize: 12)
        self.textLabel.textColor = UIColor.gray
        self.addSubview(self.textLabel)

        self.reloadData()
    }
    
    @objc private func timeAction(button: UIButton) {
        button.isSelected = !button.isSelected
        self.onClick?(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        BoneCustomPopup.Color.line.setStroke()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.close()
        path.stroke()
        super.draw(rect)
    }
}