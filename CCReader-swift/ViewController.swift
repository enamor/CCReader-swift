//
//  ViewController.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CCReaderlDateSource {
    let path = Bundle.main.path(forResource: "demo1", ofType: "txt")
    
    var catalogue: [CCCatalogueProtocol]?
    
    func catalogueOfReader(in reader: CCReaderController, callback: @escaping ([CCCatalogueProtocol]) -> ()) {
        
        if let path = path {
            
            if let text = CCReaderTXTUtil.readerTxt(from: path) {
                catalogue = CCReaderTXTUtil.catalogue(text: text)
                
                if let cata = catalogue {
                    callback(cata)
                }
            }
            
        }
    }
    
    func reader(_ reader: CCReaderController, contentForChaptersAt index: Int, callback: @escaping (String) -> ()) {
        if let path = path, let cata = catalogue {
            
            
            if let text = CCReaderTXTUtil.readerTxt(from: path) {
                let content = CCReaderTXTUtil.content(by: cata, at: index, from: text)
                
                if let content = content {
                    callback(content)
                }
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()


        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        btn.backgroundColor = UIColor.gray
        btn.addTarget(self, action: #selector(self.btnAction), for: .touchUpInside)
        self.view.addSubview(btn)
        
    }
    
    @objc func btnAction()  {
        let reader = CCReaderController()
        reader.dataSource = self
        self.present(reader, animated: false, completion: nil)
    }


}

