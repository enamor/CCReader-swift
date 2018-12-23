//
//  CCReaderBottomBarItem.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/15.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderBottomBarItem: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        titleLabel?.textAlignment = .center
        imageView?.contentMode = .scaleAspectFit
        titleLabel?.font  = UIFont.systemFont(ofSize: 14)
    }
    
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleX = 0
        let titleY = contentRect.size.height * 0.55
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height - titleY
        return CGRect(x: CGFloat(titleX), y: titleY, width: titleW, height: titleH)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.width
        let imageH = contentRect.size.height * 0.7;
        return CGRect(x: 0, y: 0, width: imageW, height: imageH)
    }
    
}
