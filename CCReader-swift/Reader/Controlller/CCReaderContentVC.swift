//
//  CCReaderContentController.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderContentVC: UIViewController {

    let textView = CCReaderContentView()
    var text: NSAttributedString? {
        didSet {
            cc_fillData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white

        textView.backgroundColor = UIColor.clear
        textView.frame = UIScreen.main.bounds
        self.view.addSubview(textView)
        
        
        textView.backgroundColor = UIColor.lightGray
        
        cc_fillData()
    }

}
extension CCReaderContentVC {
    private func cc_fillData() {
        textView.text = text
    }
}


import CoreText
class CCReaderContentView: UIView {
    var text: NSAttributedString? {
        didSet {
            cc_fillData()
        }
    }
    
    var contentFrame: CTFrame?
    
    private func cc_fillData() {
        guard let text = text else {
            return
        }
        let setterRef = CTFramesetterCreateWithAttributedString(text)
        let path = CGPath(rect: UIScreen.main.bounds, transform: nil)
        contentFrame = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, text.length), path, nil)
        
        
        self.setNeedsLayout()
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let contentFrame = contentFrame,
            let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: UIScreen.main.bounds.size.height)
        ctx.scaleBy(x: 1, y: -1)
        CTFrameDraw(contentFrame, ctx)
    }

}
