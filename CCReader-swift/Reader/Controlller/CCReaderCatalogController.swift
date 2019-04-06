//
//  CCReaderCatalogController.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/23.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderCatalogController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.addSubview(btn)
        btn.backgroundColor = UIColor.gray
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
    }
    
    @objc func btnAction()   {
        
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = .reveal
        animation.subtype = .fromRight
        view.window?.layer.add(animation, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
