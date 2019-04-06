//
//  CCReaderPageController.swift
//  CCReader-swift
//
//  Created by zhouen on 2018/10/30.
//  Copyright © 2018年 zhouen. All rights reserved.
//

import UIKit

class CCReaderController: UIViewController {
    
    var catalogueData = [CCCatalogueProtocol]()

    var viewModel: CCReaderViewModel
    
    var currentVC = CCReaderContentVC()
    
    var transiting: Bool = false
    
    var pageViewController: UIPageViewController
    
    
    init(dataSource: CCReaderProtocol) {
        self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: [UIPageViewController.OptionsKey.spineLocation:NSNumber(value:UIPageViewController.SpineLocation.min.rawValue)])
        
        self.viewModel = CCReaderViewModel(cc: dataSource)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cc_initSubview()
        
        cc_initObserver()
        
        cc_initFirstPage()
        
        cc_requestData()
    }
}



// MARK: - private
private extension CCReaderController {
    
    func cc_initSubview() {
        
        //指定代理
        pageViewController.delegate = self;
        pageViewController.dataSource = self;
        //是否双面显示，默认为NO
        pageViewController.isDoubleSided = false;
        
        self.addChild(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        //设置frame
        pageViewController.view.frame = self.view.bounds;
        
        
//        let funcView = CCReaderSettingView(frame: self.view.bounds)
//        self.view.addSubview(funcView)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(tap:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func cc_initFirstPage() {
        let firstPageVc = self.currentVC
        pageViewController.setViewControllers([firstPageVc], direction: .reverse, animated: false, completion: nil)
        
        viewModel.beginLoadData { [weak self] in
            print("\(self?.viewModel.pageText) + ////" )
            
            
            DispatchQueue.main.async {
                self?.currentVC.text = self?.viewModel.pageText
            }
        }
        
    }
    
    func cc_requestData() {
        cc_reloadData()
    }
    
    
    // MARK: - 事件监听
    func cc_initObserver() {
        // MARK: - 设置背景颜色
        CCReaderSettingView.shared.bgTypeCallBack = { [weak self] (type) in
            
            
            if CCReaderSettingUtil.nightMode() || type == .black {
                self?.currentVC.themeBgType = type
                self?.viewModel.reloadBecauseNightModeChanged()
                self?.currentVC.text = self?.viewModel.pageText;
            } else {
                self?.currentVC.themeBgType = type
            }
            
        }
        
        CCReaderSettingView.shared.fontCallBack = {
            self.viewModel.reloadPage()
            
            self.currentVC.chapterIndex = self.viewModel.chapterIndex;
            self.currentVC.pageIndex = self.viewModel.pageIndex;
            self.currentVC.text = self.viewModel.pageText;
            
//            self.currentVC.text = NSAttributedString(string: "")
        }
        
        CCReaderFunctionView.shared.actionCallBack = { [weak self] (type) in
            switch type {
            case .actionTypeTopBack:
                print("返回")
            case .actionTypeBottomOne:
                print("目录")
                self?.catalogAction()
            case .actionTypeBottomTwo:
                if CCReaderSettingUtil.nightMode() {
                    self?.currentVC.themeBgType = CCReaderBGType.yellow
                } else {
                    self?.currentVC.themeBgType = CCReaderBGType.black
                }
                
                self?.viewModel.reloadBecauseNightModeChanged()
                self?.currentVC.text = self?.viewModel.pageText;
                print("夜间")
            case .actionTypeBottomThreee:
                print("设置")
                CCReaderFunctionView.dismiss()
                CCReaderSettingView.show()
            case .actionTypeBottomFour:
                print("返回")
            }
        }
    }
    
    
    func catalogAction() {
        let vc = CCReaderCatalogController()
        let animation = CATransition()
        animation.duration = 0.3
        animation.type = .moveIn
        animation.subtype = .fromLeft
        view.window?.layer.add(animation, forKey: nil)
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    @objc func tap(tap: UITapGestureRecognizer) {
        let point = tap.location(in: self.view)
        if point.x < CC_R_SCREEN_WIDTH * 0.2  ||
            point.x > CC_R_SCREEN_WIDTH * 0.8 ||
            point.y < CC_R_SCREEN_HEIGHT * 0.2 ||
            point.y > CC_R_SCREEN_HEIGHT * 0.8 {
            return
        }
        CCReaderFunctionView.show()
    }

}

// MARK: - public
extension CCReaderController {
    func cc_reloadData() {
        
    }
}

// MARK: - delegare
extension CCReaderController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    /// 上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if transiting { return nil }
        
        if let vc =  viewController as? CCReaderContentVC {
            viewModel.chapterIndex = vc.chapterIndex
            viewModel.pageIndex = vc.pageIndex
        }
        
        currentVC = CCReaderContentVC()
        let hasNext = viewModel.initPrePage {
            [unowned self]
            (error) in
            if let error = error {
                print(error.localizedDescription)
                
            } else {
                self.currentVC.chapterIndex = self.viewModel.chapterIndex;
                self.currentVC.pageIndex = self.viewModel.pageIndex;
                self.currentVC.text = self.viewModel.pageText;
            }
        }
        
        if !hasNext  {
            return nil
        }
        
        return currentVC
        
    }
    
    /// 下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if transiting { return nil }
        
        currentVC = CCReaderContentVC()
        
        if let vc =  viewController as? CCReaderContentVC {
            viewModel.chapterIndex = vc.chapterIndex
            viewModel.pageIndex = vc.pageIndex
        }
        
        let hasNext = viewModel.initNextPage {
            [unowned self]
            (error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.currentVC.text = self.viewModel.pageText
                self.currentVC.pageIndex = self.viewModel.pageIndex;
                self.currentVC.chapterIndex = self.viewModel.chapterIndex;
            }
        }
        
        if !hasNext  {
            return nil
        }
        
        return currentVC
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        transiting = true
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        transiting = false

        if false == completed {
            if let vc =  previousViewControllers.first as? CCReaderContentVC {
                viewModel.chapterIndex = vc.chapterIndex
                viewModel.pageIndex = vc.pageIndex
            }
        }
    }
    
}

