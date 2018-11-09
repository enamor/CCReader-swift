//
//  CCReaderPageController.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderController: UIViewController {
    
    var dataSource: CCReaderlDateSource?
    var catalogueData = [CCCatalogueProtocol]()

    var viewModel = CCReaderViewModel()
    
    
    var currentVC = CCReaderContentVC()
    
    var pageViewController: UIPageViewController
    init() {
        self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation:NSNumber(value:UIPageViewController.SpineLocation.min.rawValue)])
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cc_initSubview()
        
        cc_initFirstPage()
        
        cc_requestData()
    }
}



// MARK: - private
extension CCReaderController {
    
    private func cc_initSubview() {
        
        //指定代理
        pageViewController.delegate = self;
        pageViewController.dataSource = self;
        //是否双面显示，默认为NO
        pageViewController.isDoubleSided = false;
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        //设置frame
        pageViewController.view.frame = self.view.bounds;
    }
    
    private func cc_initFirstPage() {
        let firstPageVc = self.currentVC
        pageViewController.setViewControllers([firstPageVc], direction: .reverse, animated: false, completion: nil)
        
    }
    
    private func cc_requestData() {
        cc_reloadData()
    }
}

// MARK: - public
extension CCReaderController {
    func cc_reloadData() {
        guard let dataSource = dataSource else {
            return
        }
        
        dataSource.catalogueOfReader(in: self) { (data) in
            self.viewModel.catelogList = data
        }
        
        dataSource.reader(self, contentForChaptersAt: 0) { (text) in
            self.viewModel.chapterContent = text
            
            self.viewModel.initPageList(isNextPage: true)
            
            self.currentVC.text = self.viewModel.pageText
        }
        
    }
}

// MARK: - delegare
extension CCReaderController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let (isHasNextPage,isNextChapter) = self.viewModel.initPrePage()
        if !isHasNextPage {
            return nil
        }
        
        currentVC = CCReaderContentVC()
        
        if isNextChapter {
            guard let dataSource = dataSource else {
                return nil
            }
            dataSource.reader(self, contentForChaptersAt: self.viewModel.chapterIndex) { (text) in
                self.viewModel.chapterContent = text
                
                self.viewModel.initPageList(isNextPage: false)
                
                self.currentVC.text = self.viewModel.pageText
            }
        } else {
            currentVC.text = viewModel.pageText
        }
        
        return currentVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let (isHasNextPage,isNextChapter) = viewModel.initNextPage()
        if !isHasNextPage {
            return nil
        }
        currentVC = CCReaderContentVC()
        
        if isNextChapter {
            guard let dataSource = dataSource else {
                return nil
            }
            dataSource.reader(self, contentForChaptersAt: self.viewModel.chapterIndex) { (text) in
                self.viewModel.chapterContent = text
                
                self.viewModel.initPageList(isNextPage: true)
                
                self.currentVC.text = self.viewModel.pageText
            }
        } else {
            currentVC.text = viewModel.pageText
        }
        
        
        print(currentVC.text)
        
        return currentVC
    }
}

