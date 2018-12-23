//
//  CCError.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/1.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import Foundation

struct CCError: Error {
    var desc = ""
    var code = 0
    var localizedDescription: String {
        return desc
    }
    
    init(_ desc: String, code: Int = 0) {
        self.code = code
        self.desc = desc
    }
}
