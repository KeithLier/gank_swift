//
//  FreeViewController.swift
//  gank_swift
//
//  Created by keith on 2019/10/24.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire

class FreeViewController: UIViewController {
    
    @IBOutlet weak var topMenuScrollView: TopMenuScrollView!
    @IBOutlet weak var scrollView: UIScrollView!

    var categoryies: Array<AnyObject> = [] as Array<AnyObject>
    var menus: Array<AnyObject> = [] as Array<AnyObject>

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.navigationItem.title = "闲读"
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
        
        self.loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "分类阅读"
    }

    func loadCategories() {
        let url = "http://gank.io/api/xiandu/categories"
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    self.categoryies = dict["results"] as! Array
                    self.setupTopMenuView()
                    self.addController()
                }
            }
        }
    }
        
    func setupTopMenuView() {
        topMenuScrollView.delegate = self
        let titles: NSMutableArray = []
        for category in self.categoryies {
            let name: String = category["name"] as! String
            titles.add(name)
        }
        topMenuScrollView.titles = titles as? Array<String>
    }
    
    func addController() {
        for category in categoryies {
            let page: FreePageViewController = FreePageViewController()
            page.category = category["en_name"] as! String
            self.addChild(page)
        }
        
        self.addControllerView(index: 0)
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

extension FreeViewController: TopMenuScrollViewDelegate {
    func topMenuScrollView(_ scrollView: TopMenuScrollView, selectedIndex index: Int) {
        self.addControllerView(index: index)
        let x = self.scrollView.frame.size.width * CGFloat(index)
        let point: CGPoint = CGPoint(x: x, y: self.scrollView.contentOffset.y)
        self.scrollView.setContentOffset(point, animated: true)
    }
}


