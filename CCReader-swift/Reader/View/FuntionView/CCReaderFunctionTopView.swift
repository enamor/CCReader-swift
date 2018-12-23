//
//  CCReaderFunctionTopView.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/14.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit



class CCReaderFunctionTopView: UIView {
    typealias CallBack = (Int) -> Void

    var callBack: CallBack?
    
    let backBtn = UIButton()
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
        safeArea.addSubview(backBtn);
        
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()
        
        safeArea.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 44)
        safeArea.frame.origin.y = self.frame.height - 44
        
        backBtn.frame.size = CGSize(width: 30, height: 30)
        backBtn.frame.origin = CGPoint(x: 15, y: 7)
        
        backBtn.backgroundColor = UIColor.blue
    }
    
}
