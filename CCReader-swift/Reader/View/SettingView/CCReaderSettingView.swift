//
//  CCReaderSettingView.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/16.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderSettingView: UIView {
    static let shared = CCReaderSettingView()
    
    var bgTypeCallBack: ReaderClosureBGType?
    var fontCallBack: ReaderFontChangedCallBack?
    
    let safeView = UIView()
    
    let fontView = CCReaderSettingFontView()
    let bgView = CCReaderSettingBgView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        initSubview()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview() {
        self.addSubview(safeView)
        
        safeView.addSubview(fontView)
        safeView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        
        safeView.addSubview(bgView)
        
        bgView.callBack = {[weak self] (type) in
            if let bgType = self?.bgTypeCallBack {
                bgType(type)
            }
        }
        
        fontView.callBack = { [weak self] in
            if let fontCall = self?.fontCallBack {
                fontCall()
            }
        }
        
        
        safeView.frame = CGRect(x: 0, y: CC_R_SCREEN_HEIGHT, width: CC_R_SCREEN_WIDTH, height: 250)
        fontView.frame = CGRect(x: 0, y: 0, width: safeView.frame.width, height: 55)
        bgView.frame = CGRect(x: 0, y: 55, width: safeView.frame.width, height: 55)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }

}

extension CCReaderSettingView {
    class func show() {
        let window = UIApplication.shared.delegate?.window
        let functionView = CCReaderSettingView.shared
        functionView.frame = CC_R_SCREEN_BOUNDS
        window??.addSubview(functionView)
        functionView.show()
        
    }
    
    class func dismiss() {
        CCReaderSettingView.shared.dismiss()
    }
}

private extension CCReaderSettingView {
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.safeView.transform = CGAffineTransform.identity
        }) { (isfi) in
            self.removeFromSuperview()
        }
    }
    
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.safeView.transform = CGAffineTransform(translationX: 0, y: -250)
        };
    }
}
