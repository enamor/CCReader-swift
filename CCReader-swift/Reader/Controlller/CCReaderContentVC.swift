//
//  CCReaderContentController.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderContentVC: UIViewController {

    var chapterIndex: Int = 0
    var pageIndex: Int = 0
    var themeBgType: CCReaderBGType? {
        didSet {
            setThemeBgType()
        }
    }
    let textView = CCReaderContentView(frame: CC_R_Novel_Drwa_Rect)
    var text: NSAttributedString? {
        didSet {
            cc_fillData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let image = CCReaderSettingUtil.getBGImage() {
            view.layer.contents = image.cgImage
        }
        view.addSubview(textView)
        textView.backgroundColor = UIColor.clear
    }

}
private extension CCReaderContentVC {
    func cc_fillData() {
        textView.text = text
    }
    
    func setThemeBgType() {
        guard let bgType = themeBgType else {
            return
        }
        CCReaderSettingUtil.bgThemeType = bgType
        if let image = CCReaderSettingUtil.getBGImage() {
            view.layer.contents = image.cgImage
        }
    }
    
}


import CoreText
class CCReaderContentView: UIView {
    var text: NSAttributedString? {
        didSet {
            cc_fillData()
            setNeedsDisplay()
        }
    }
    
    var contentFrame: CTFrame?
    
    private func cc_fillData() {
        guard let text = text else {
            return
        }
        let setterRef = CTFramesetterCreateWithAttributedString(text)
        let path = CGPath(rect: self.bounds, transform: nil)
        contentFrame = CTFramesetterCreateFrame(setterRef, CFRangeMake(0, text.length), path, nil)

    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let contentFrame = contentFrame,
            let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        ctx.textMatrix = CGAffineTransform.identity
        ctx.translateBy(x: 0, y: self.bounds.size.height)
        ctx.scaleBy(x: 1, y: -1)
        CTFrameDraw(contentFrame, ctx)
    }

}
