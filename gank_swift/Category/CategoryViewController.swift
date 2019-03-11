//
//  CategoryViewController.swift
//  gank_swift
//
//  Created by keith on 2019/2/21.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var topMenuScrollView: TopMenuScrollView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var titles: [String] = []
    
    private var startOffsetX: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "分类阅读"
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
        titles = ["all","iOS","Android","瞎推荐","前端","App","休息视频","福利"]
        topMenuScrollView.delegate = self
        topMenuScrollView.titles = titles
        
        let width = scrollView.frame.size.width * CGFloat(titles.count)
        scrollView.contentSize = CGSize(width: width, height: scrollView.frame.size.height)
        addControllers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "分类阅读"

    }

    func addControllers() {
        for title in titles {
            let page: CategoryPageController = CategoryPageController()
            page.category = title
            self.addChild(page)
        }
        
        addControllerView(index: 0)
    }
    
    func addControllerView(index: Int) {
        if self.children.count == 0 {
            return
        }
        let page = self.children[index]
        if page.view.superview != nil {
            return
        }
        let size = scrollView.frame.size
        let x = size.width * CGFloat(index)
        let frame = CGRect(x: x, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        page.view.frame = frame
        scrollView.addSubview(page.view)
    }
}

extension CategoryViewController: TopMenuScrollViewDelegate {
    func topMenuScrollView(_ scrollView: TopMenuScrollView, selectedIndex index: Int) {
        addControllerView(index: index)
        let x = self.scrollView.frame.size.width * CGFloat(index)
        let point: CGPoint = CGPoint(x: x, y: self.scrollView.contentOffset.y)
        self.scrollView.setContentOffset(point, animated: true)
    }
}

extension CategoryViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var progress: CGFloat = 0
        var targetIndex = 0
        var sourceIndex = 0
        
        progress = scrollView.contentOffset.x.truncatingRemainder(dividingBy: scrollView.bounds.width) / scrollView.bounds.width
        if progress == 0 {
            return
        }
        let index = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if scrollView.contentOffset.x > startOffsetX { // 左滑
            sourceIndex = index
            targetIndex = index + 1
            guard targetIndex < titles.count else { return }
        } else {
            sourceIndex = index + 1
            targetIndex = index
            progress = 1 - progress
            if targetIndex < 0 {
                return
            }
        }
        if progress > 0.998 {
            progress = 1
        }

        topMenuScrollView.setTitleWithProgress(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
}
