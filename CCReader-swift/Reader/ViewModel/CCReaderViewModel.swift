//
//  CCReaderViewModel.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

protocol CCReaderlDateSource: AnyObject {
    
    func catalogueOfReader(in reader: CCReaderController, callback:@escaping ([CCCatalogueProtocol])->())
    
    func reader(_ reader: CCReaderController, contentForChaptersAt index: Int , callback:@escaping (String)->())
}

class CCReaderViewModel {
    
    /// 目录列表
    var catelogList: [CCCatalogueProtocol]?
    
    /// 当前章节的全部内容
    var chapterContent: String?
    
    /// 当前章节的索引
    var chapterIndex: Int = 0
    
    /// 当前章节当前页面的索引
    var pageIndex: Int = 0
    
    /// 当前章节的所有页面列表
    var pageList: [NSAttributedString]?
    
    /// 当前章节当前页面的内容
    var pageText: NSAttributedString? {
        get {
            return pageList?[pageIndex]
        }
    }

}

extension CCReaderViewModel {

    /// (a,b)
    func initPrePage() -> (Bool,Bool)  {
        if chapterIndex == 0 && pageIndex == 0 {
            return (false,false)
        }
        if pageIndex <= 0 { //跨章节
            chapterIndex -= 1
            
            return (true,true)
            
        } else {
            pageIndex -= 1 ;
            return (true,false)
        }
    }
    
    func initNextPage() -> (Bool,Bool)  {
        guard let catelogList = catelogList, let pageList = pageList else {
            return (false,false)
        }
        if (chapterIndex == catelogList.count - 1 && pageIndex == pageList.count - 1) {
            return (false,false)
        }
        
        if pageIndex >=  pageList.count - 1 { //跨章节
            chapterIndex += 1;
            pageIndex = 0;
            
            //分页处理
            return (true,true)
            
        } else {
            pageIndex += 1
            
            return (true,false)
        }
    }
    
    
}

extension CCReaderViewModel {
    func initPageList(isNextPage: Bool) {
        //可能需要异步获取章节内容
        
        if let chapterContent = chapterContent {
            pageList = CCReaderTXTUtil.paging(text: chapterContent, by: UIScreen.main.bounds.size)
            if isNextPage {
                pageIndex = 0
                
            } else {
                if let pageList = pageList {
                   pageIndex = pageList.count - 1
                }
            }
        }
    }
}
