//
//  CCCatalogue.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

protocol CCCatalogueProtocol {
    var cid: Int { get set }
    var title: String { get set }
    var content: String { get set }
    var position: Int { get set }
}


class CCCatalogue: CCCatalogueProtocol{
    var cid: Int = 0
    
    var title: String = ""
    
    var content: String = ""
    
    var position: Int = 0
    
}
