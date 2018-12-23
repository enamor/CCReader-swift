//
//  CCReaderProtocol.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/11/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

protocol CCReaderProtocol {
    func catalogueOfReader(callback: @escaping ([CCCatalogueProtocol]) -> ())
    
    func reader(contentForChaptersAt index: Int, callback: @escaping (String) -> ())
} 
