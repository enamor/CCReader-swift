//
//  CCReaderFunctionView.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/14.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

enum ActionType:Int {
    case actionTypeBottomOne = 11, actionTypeBottomTwo, actionTypeBottomThreee, actionTypeBottomFour
    case actionTypeTopBack = 21
}

class CCReaderFunctionView: UIView {
    typealias ActionCallBack = (ActionType) -> Void
    
    static let shared = CCReaderFunctionView()
    
    var actionCallBack: ActionCallBack?
    let topView = CCReaderFunctionTopView()
    let bottomView = CCReaderFunctionBottomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubview()
        
        bottomView.callBack = { [weak self] (index) in
            if let actionCallBack = self?.actionCallBack {
                guard let type = ActionType(rawValue: index) else { return }
                actionCallBack(type)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initSubview() {
        self.addSubview(topView)
        self.addSubview(bottomView)
        
        topView.backgroundColor = UIColor.white
        bottomView.backgroundColor = UIColor.black
        
       
        
        
        topView.frame = CGRect(x: 0, y: -kNav_Height, width: Int(CC_R_SCREEN_WIDTH), height: kNav_Height)
        bottomView.frame = CGRect(x: 0, y: Int(CC_R_SCREEN_HEIGHT), width: Int(CC_R_SCREEN_WIDTH) , height: 49 + kSafeAreaBottomHeight )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss()
    }
    
}

extension CCReaderFunctionView {
    
    class func show() {
        let window = UIApplication.shared.delegate?.window
        let functionView = CCReaderFunctionView.shared
        functionView.frame = CC_R_SCREEN_BOUNDS
        window??.addSubview(functionView)
        functionView.show()
        
    }
    
    class func dismiss() {
        CCReaderFunctionView.shared.dismiss()
    }
    
}

private extension CCReaderFunctionView {
    
    func show() {
        UIView.animate(withDuration: 0.3) {
            self.topView.transform = CGAffineTransform(translationX: 0, y: CGFloat(kNav_Height))
            self.bottomView.transform = CGAffineTransform(translationX: 0, y: -CGFloat(49 + kSafeAreaBottomHeight))
        };
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.transform = CGAffineTransform.identity
            self.bottomView.transform = CGAffineTransform.identity
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
}

