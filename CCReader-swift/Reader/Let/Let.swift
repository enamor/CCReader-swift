//
//  File.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/15.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

/// 屏幕宽度
let CC_R_SCREEN_WIDTH = UIScreen.main.bounds.width

/// 屏幕高度
let CC_R_SCREEN_HEIGHT = UIScreen.main.bounds.height

/// 屏幕bounds
let CC_R_SCREEN_BOUNDS = UIScreen.main.bounds

/// 判断是不是iPad
let CC_R_IS_IPAD = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad

/// 判断是不是iPhoneX XS
let CC_R_IS_IPHONEX = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1125, height: 2436), UIScreen.main.currentMode?.size ?? CGSize.zero) && !CC_R_IS_IPAD : false

let CC_R_IS_IPHONEXR = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 828, height: 1792), UIScreen.main.currentMode?.size ?? CGSize.zero) && !CC_R_IS_IPAD : false

let CC_R_IS_IPHONEXS_MAX = UIScreen.instancesRespond(to: #selector(getter: UIScreen.currentMode)) ? __CGSizeEqualToSize(CGSize(width: 1242, height: 2688), UIScreen.main.currentMode?.size ?? CGSize.zero) && !CC_R_IS_IPAD : false


/// 判断iPhoneX系列
let R_IS_IPHONEX_SERIES = (CC_R_IS_IPHONEX || CC_R_IS_IPHONEXR || CC_R_IS_IPHONEXS_MAX)


let kSafeAreaBottomHeight = (R_IS_IPHONEX_SERIES ? 34 : 0)

let kNav_Height = (R_IS_IPHONEX_SERIES ? 88  : 64)

let kStatusBar_Height = (R_IS_IPHONEX_SERIES ? 44  : 22)

let CC_R_Novel_Drwa_Rect = CGRect(x: 20, y: CGFloat(kStatusBar_Height + 15), width: CC_R_SCREEN_WIDTH - 20 - 15, height: CC_R_SCREEN_HEIGHT - CGFloat(kStatusBar_Height) - 15  - 20)
