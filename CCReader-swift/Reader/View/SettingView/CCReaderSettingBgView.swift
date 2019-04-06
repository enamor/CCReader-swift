//
//  CCReaderSettingBgView.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/12/16.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit


typealias ReaderClosureBGType = (CCReaderBGType) -> Void

class CCReaderSettingBgView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    var callBack: ReaderClosureBGType?
    
    var collectionView: UICollectionView?
    var flowLayout: UICollectionViewFlowLayout?
    
    
    let reuseIdentifier = "CCPageControlCell"
    
    var currentCell: UICollectionViewCell?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cc_initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let bgType = CCReaderBGType(rawValue: indexPath.item + 11) {
            let image = CCReaderSettingUtil.getBGImage(bgType: bgType)
            cell.layer.contents = image?.cgImage
            
            if bgType == CCReaderSettingUtil.bgThemeType {
                cell.layer.borderWidth = 2.0
                cell.layer.borderColor = UIColor.red.cgColor
                currentCell = cell
            }
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let typeSign = indexPath.item + 11
        
        let cell = collectionView.cellForItem(at: indexPath)
        let type = CCReaderBGType(rawValue: typeSign) ?? CCReaderBGType.yellow
        if let callBack = callBack {
            callBack(type)
            
            
            self.currentCell?.layer.borderWidth = 0
            
            cell?.layer.borderWidth = 2.0
            cell?.layer.borderColor = UIColor.red.cgColor
            currentCell = cell
            
        }
    }

    
    func cc_initSubview() {
        
        flowLayout = UICollectionViewFlowLayout()
        guard let flowLayout = flowLayout  else {
            return
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        self.addSubview(collectionView!)
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.bounces = false
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
    
        // 设置cell的大小和细节
        flowLayout.scrollDirection = .horizontal;
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 18, bottom: 10, right: 18)
        collectionView!.showsVerticalScrollIndicator = false;
        
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView?.frame = self.bounds
        flowLayout?.itemSize = CGSize(width: 60, height: self.frame.height)
        
    }

}
