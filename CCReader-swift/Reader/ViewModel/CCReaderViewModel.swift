//
//  CCReaderViewModel.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit


class CCReaderViewModel {
    
    var dataSource: CCReaderProtocol
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
    
    init(cc: CCReaderProtocol) {
        self.dataSource = cc
    }

}

extension CCReaderViewModel {

    /// (a,b) isHasNextPage,isNextChapter
    func initPrePage(callback: @escaping (CCError?) -> ()) -> Bool  {
        if chapterIndex == 0 && pageIndex == 0 {
            let error = CCError("到头了")
            callback(error)
            
            return false
        
        }
        if pageIndex <= 0 { //跨章节
            chapterIndex -= 1
            
            self.dataSource.reader(contentForChaptersAt: chapterIndex) {
                [unowned self]
                (chapterContent) in
                
                self.chapterContent = chapterContent
                self.initPageList(isNextPage: false)
                callback(nil)
            }
            
        } else {
            pageIndex -= 1 ;
            callback(nil)
        }
        
        return true
    }
    
    
    func initNextPage(callback: @escaping (CCError?) -> ()) -> Bool  {
        guard let catelogList = catelogList, let pageList = pageList else {
            let error = CCError("目录请求失败")
            
            callback(error)
            return false
            
        }
        if (chapterIndex == catelogList.count - 1 && pageIndex == pageList.count - 1) {
            let error = CCError("最后一章节")
            callback(error)
            return false
        }
        
        if pageIndex >=  pageList.count - 1 { //跨章节
            chapterIndex += 1;
            pageIndex = 0;
            
            self.dataSource.reader(contentForChaptersAt: chapterIndex) {
                [unowned self]
                (chapterContent) in
                
                self.chapterContent = chapterContent
                self.initPageList(isNextPage: true)
                
                callback(nil)
            }
            
            
        } else {
            pageIndex += 1
            
            callback(nil)
        }
        
        return true
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
    
    func reloadBecauseNightModeChanged() {
        guard let chapterContent = chapterContent else { return }
        pageList = CCReaderTXTUtil.paging(text: chapterContent, by: UIScreen.main.bounds.size)
    }
    
    func reloadPage() {
        if pageIndex == 0 {
            initPageList(isNextPage: true)
            return;
        }
//        chapterContent = "清朝时期，八国联军在北京掠走很多宝物，而且后来经过炒作后，拍卖的价格都是非常高。近日，微博用户@夏公@Liu Yangfa表示，在法国巴黎Tessier & Sarrou et As.aties举行的亚洲古董艺术拍卖会上，圆明园的龙头将被拍卖240万欧元，这引发了关于该动物头在微博上的价值的争议。据报道，买方是一个亚洲人，似乎正在为别人代拍的。也就是在他后面，还有一个主人。龙头以前是台湾收藏家收藏的。他称，综合各种因素，自己“认为这件东西是圆明园的”。但他也向记者坦言，确实有其他专家对这件拍品的真伪有疑问，目前“不能确认100%是真的”。"
//
//        let text = "八国联军"
        guard let chapterContent = chapterContent else { return }
        guard let text = pageText?.string else { return }
        let temp = text.prefix(40)
        if let r = chapterContent.range(of: temp) {
            let index = chapterContent.index(before: r.lowerBound)
            let preText = String(chapterContent[...index])
            var afterText = String(chapterContent[index...])
            afterText.remove(at: afterText.startIndex);
            
            let prePageList = CCReaderTXTUtil.paging(text: preText, by: UIScreen.main.bounds.size)
            let afterPageList = CCReaderTXTUtil.paging(text: afterText, by: UIScreen.main.bounds.size)
            
            if var prePageList = prePageList , let afterPageList = afterPageList {
                
                if prePageList.last!.length < afterPageList.first!.length {
                    let count = abs(Int(afterPageList.first!.length - prePageList.last!.length - 10))
                    let attString = afterPageList.first!.attributedSubstring(from: NSRange(location: 0, length: count))
                    
                    let newValue = NSMutableAttributedString(attributedString: prePageList.last!)
                    prePageList.remove(at: prePageList.count - 1)
                    newValue.append(attString)
                    prePageList.append(newValue)

                }
                self.pageList = prePageList + afterPageList
                self.pageIndex = prePageList.count
                
            }
            
        
        }
    }
    
    
    
    /**
    - (void)updatePage {
    
    NSString *text = [self.pageContent string];
    if (_pageIndex == 0) {
    //当前页面为首页无需分开处理
    [self p_initPageList];
    } else {
    CGFloat subIndex = 10;
    if (text.length < 40) {
    subIndex = text.length;
    }
    NSString *subtext = [text substringToIndex:subIndex];
    
    NSRange range = [_chapterContent rangeOfString:subtext];
    NSString *beforeText = [_chapterContent substringToIndex:range.location];
    NSString *lastText = [_chapterContent substringFromIndex:range.location];
    
    NSArray* brray = [CCReaderContentHandleUtil textPaging:beforeText textFrame:CC_ReaderContentSize];
    NSArray* lrray = [CCReaderContentHandleUtil textPaging:lastText textFrame:CC_ReaderContentSize];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:brray];
    [array addObjectsFromArray:lrray];
    _pageList = [NSArray arrayWithArray:array];
    _pageIndex = brray.count;
    }
    
    }
  */
}


// MARK: - private
extension CCReaderViewModel {
    /// 获取目录列表
    func beginLoadData(callback: @escaping () -> ()) {
        self.dataSource.catalogueOfReader { (items) in
            self.catelogList = items
            
            self.dataSource.reader(contentForChaptersAt: 0, callback: { (chapterContent) in
                self.chapterContent = chapterContent;
                self.initPageList(isNextPage: true)
                
                callback()
            })
        }
    }
}
