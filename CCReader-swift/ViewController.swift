//
//  ViewController.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class ViewController: UIViewController,CCReaderlDateSource {
    let path = Bundle.main.path(forResource: "demo", ofType: "txt")
    
    var catalogue: [CCCatalogueProtocol]?
    
    func catalogueOfReader(in reader: CCReaderController, callback: @escaping ([CCCatalogueProtocol]) -> ()) {
        
        if let path = path {
            
            var text = try! String.init(contentsOfFile: path);
            text = (text as NSString).replacingOccurrences(of: "\n\n", with: "\n")
            catalogue = CCReaderTXTUtil.catalogue(text: text)
            
            if let cata = catalogue {
                callback(cata)
            }
        }
        
    }
    
    func reader(_ reader: CCReaderController, contentForChaptersAt index: Int, callback: @escaping (String) -> ()) {
        if let path = path, let cata = catalogue {
            var text = try! String.init(contentsOfFile: path);
            
            text = (text as NSString).replacingOccurrences(of: "\n\n", with: "\n")
            let content = CCReaderTXTUtil.content(by: cata, at: index, from: text)
            
            if let content = content {
                callback(content)
            }
        }
    }
    
//    + (NSString *)readContentOfFilePath:(NSString *)path {
//    //GBK
//    unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//
//    NSString *string = [NSString stringWithContentsOfFile:path encoding:encode error:nil];
//
//    if (!string) {
//    string = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    }
//    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    string = [string stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
//    return string;
//    }
    

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

