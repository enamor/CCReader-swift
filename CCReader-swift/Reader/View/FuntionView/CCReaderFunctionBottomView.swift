//
//  CCReaderFunctionBottomView.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/14.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderFunctionBottomView: UIView {
    typealias CallBack = (Int) -> Void
    var callBack: CallBack?
    
    let titles = ["目录",
                  "夜间",
                  "设置",
                  "更多"]
    
    let items = [CCReaderBottomBarItem(),
                 CCReaderBottomBarItem(),
                 CCReaderBottomBarItem(),
                 CCReaderBottomBarItem()]
    
    let safeArea = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview() {
        self.addSubview(safeArea);

        for (index , item) in items.enumerated() {
            safeArea.addSubview(item)
            item.tag = index + 11
            item.setTitle(titles[index], for: .normal)
            item.addTarget(self, action: #selector(self.itemAction(_:)), for: .touchUpInside)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        safeArea.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 49)
        
        let width = self.frame.width / CGFloat(self.items.count)
        for (index, item) in items.enumerated() {
            let x = Double(index) * Double(width)
            item.frame = CGRect(x: x, y: 0.0, width: Double(width), height: 49.0)
        }
    }
    
    
    @objc func itemAction(_ item: UIButton) {
        if let callBack = callBack {
            callBack(item.tag)
        }
    }
}
