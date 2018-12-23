//
//  CCReaderSettingFontView.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/16.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

typealias ReaderFontChangedCallBack = () -> Void
class CCReaderSettingFontView: UIView {

    var callBack: ReaderFontChangedCallBack?
    
    let addBtn = UIButton()
    let cutBtn = UIButton()
    let fontlabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubview() {
        self.addSubview(addBtn)
        self.addSubview(cutBtn)
        self.addSubview(fontlabel)
        
        addBtn.setTitle("A+", for: .normal)
        addBtn.tag = 11
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        cutBtn.setTitle("A-", for: .normal)
        cutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        
        
        fontlabel.textAlignment = .center
        fontlabel.font = UIFont.systemFont(ofSize: 18)
        fontlabel.textColor = UIColor.white
        
        
        let font = CCReaderSettingUtil.readerFontSize
        fontlabel.text = "\(font)"
        
        addBtn.addTarget(self, action: #selector(self.addOrCutFont(sender:)), for: .touchUpInside)
        cutBtn.addTarget(self, action: #selector(self.addOrCutFont(sender:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cutBtn.frame = CGRect(x: 15, y: 0, width: 60, height: self.frame.height)
        
        fontlabel.frame = CGRect(x: 60 + 15 + 20, y: 0, width: 60, height: self.frame.height)
        
        let x = fontlabel.frame.origin.x + fontlabel.frame.size.width + 20
        addBtn.frame = CGRect(x: x, y: 0, width: 60, height: self.frame.height)
    }
    
}

private extension CCReaderSettingFontView {
    @objc func addOrCutFont(sender: UIButton) {
        var font = CCReaderSettingUtil.readerFontSize
        
        let add = (sender.tag == 11) ?  true : false
        if add && font == CCReaderSettingUtil.r_max_font {
            return ;
        }
        
        if !add && font == CCReaderSettingUtil.r_min_font {
            return ;
        }
        
        font = add ? (font + 2) : (font - 2)
        
        if font < CCReaderSettingUtil.r_min_font || font > CCReaderSettingUtil.r_max_font {
            return ;
        }
        
        CCReaderSettingUtil.readerFontSize = font
        
        fontlabel.text = "\(font)"
        if let callBack = callBack {
            callBack()
        }
    }
}
