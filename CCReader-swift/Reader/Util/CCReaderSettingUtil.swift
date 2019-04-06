//
//  CCReaderSettingUtil.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/17.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit


enum CCReaderBGType: Int {
    case yellow = 11, green, blue, pink, black
    
    func bgImage() -> UIImage? {
        switch self {
        case .yellow:
            return UIImage(named: "CC_Raader_bg_yellow")
        case .green:
            return UIImage(named: "CC_Raader_bg_green")
        case .blue:
            return UIImage(named: "CC_Raader_bg_blue")
        case .pink:
            return UIImage(named: "CC_Raader_bg_pink")
        case .black: //夜间模式
            return UIImage(color: .black, size: UIScreen.main.bounds.size)
        }
        
    }
}


struct CCReaderSettingUtil {
    static let r_max_font = 30
    static let r_min_font = 12
    
    static let CC_READER_BGCOLOR_KEY = "CC_READER_BGCOLOR_KEY"
    static let CC_READER_FONT_KEY = "CC_READER_FONT_KEY"
    static let CC_READER_TEXT_COLOR = "CC_READER_TEXT_COLOR"

    static var bgThemeType: CCReaderBGType {
        set { changeBGType(newType: newValue) }
        get { return getBGType() }
    }
    
    /// 获取字体大小
    static var readerFontSize: Int {
        set { changeFontSize(newValue: newValue) }
        get { return getFontSize() }
    }
    
    /// 获取文本颜色
    static var readerTextColor: UIColor {
        set { changeTextColor(newValue: newValue) }
        get { return getTextColor() }
    }
    
    /// 获取背景图片
    static func getBGImage() -> UIImage? {
        return self.bgThemeType.bgImage()
    }
    
    static func getBGImage(bgType: CCReaderBGType) -> UIImage? {
        return bgType.bgImage()
    }
    
    
    //MARK - 是否为夜间模式
    static func nightMode() -> Bool {
        let isNight = self.bgThemeType == .black ? true : false
        return isNight
    }
}

private extension CCReaderSettingUtil {
    
    //背景相关
    static func changeBGType(newType: CCReaderBGType) {
        if newType == .black {
            changeTextColor(newValue: .white)
        } else {
            changeTextColor(newValue: .black)
        }
        let defaults = UserDefaults.standard
        defaults.set(newType.rawValue, forKey: CC_READER_BGCOLOR_KEY)
    }
    static func getBGType() -> CCReaderBGType {
        let defaults = UserDefaults.standard
        let type = defaults.integer(forKey: CC_READER_BGCOLOR_KEY)
        return CCReaderBGType(rawValue: type) ?? CCReaderBGType.yellow
    }
    
    //字体
    static func changeFontSize(newValue: Int) {
        if newValue < r_min_font || newValue > r_max_font { return }
        let defaults = UserDefaults.standard
        defaults.set(newValue, forKey: CC_READER_FONT_KEY)
    }
    
    static func getFontSize() -> Int {
        let defaults = UserDefaults.standard
        var fontSize = defaults.integer(forKey: CC_READER_FONT_KEY)
        if (fontSize < r_min_font || fontSize > r_max_font) {
            fontSize = 18
        }
        return fontSize
    }
    
    //字体颜色
    private static func changeTextColor(newValue: UIColor = .white) {
        let storeValue = newValue == UIColor.white ? 1000 : 2000
        let defaults = UserDefaults.standard
        defaults.set(storeValue, forKey: CC_READER_TEXT_COLOR)
    }
    
    static func getTextColor() -> UIColor {
        let defaults = UserDefaults.standard
        let storeValue = defaults.integer(forKey: CC_READER_TEXT_COLOR)
        let color = storeValue == 1000 ? UIColor.white : UIColor.black
        return color
    }
    
}

