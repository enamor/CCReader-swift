//
//  CCReaderTXTDefaultViewModel.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/11/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderTXTDefaultViewModel: CCReaderProtocol {
    
    var catalogue: [CCCatalogueProtocol]?
    var txtContent: String?
    func catalogueOfReader(callback: @escaping ([CCCatalogueProtocol]) -> ()) {
        
        
        
//        let path = Bundle.main.path(forResource: "demo1", ofType: "txt") ?? ""
//        let content = CCReaderTXTUtil.readerTxt(from: path) ?? ""
//
//        self.txtContent = content
//
//        let cat = CCReaderTXTUtil.catalogue(text: content)
//        self.catalogue = cat
//        callback(cat ?? [])
        
        DispatchQueue.global().async {
            let path = Bundle.main.path(forResource: "demo1", ofType: "txt") ?? ""
            let content = CCReaderTXTUtil.readerTxt(from: path) ?? ""
            
            self.txtContent = content
            
            DispatchQueue.main.async {
                let cat = CCReaderTXTUtil.catalogue(text: content)
                self.catalogue = cat
                callback(cat ?? [])
            }
        }
        
        
    }
    
    func reader(contentForChaptersAt index: Int, callback: @escaping (String) -> ()) {
        
        DispatchQueue.global().async {
            let path = Bundle.main.path(forResource: "demo1", ofType: "txt") ?? ""
            let contents = CCReaderTXTUtil.readerTxt(from: path) ?? ""
            
            let content = CCReaderTXTUtil.content(by: self.catalogue ?? [], at: index, from: self.txtContent!)
            
            DispatchQueue.main.async {
                if let content = content {
                    callback(content)
                }
            }
        }
        
    }
    
}
