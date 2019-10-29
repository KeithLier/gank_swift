//
//  FreeViewController.swift
//  gank_swift
//
//  Created by keith on 2019/10/24.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import PKHUD

class FreeViewController: UIViewController {
    
    @IBOutlet weak var topMenuScrollView: TopMenuScrollView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!

    var categoryies: Array<AnyObject> = [] as Array<AnyObject>
    var menus: Array<AnyObject> = [] as Array<AnyObject>

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarController?.navigationItem.title = "闲读"
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil;
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "FreeMenuViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FreeMenuViewCell")
        self.loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "分类阅读"
    }

    func loadCategories() {
        let url = "http://gank.io/api/xiandu/categories"
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show(onView: self.view)
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    self.categoryies = dict["results"] as! Array
                    self.setupTopMenuView()
                    
                    let menu: Dictionary<String, Any> = self.categoryies.first as! Dictionary<String, Any>
                    self.loadCategoryChildren(child: menu)
                }
            }
            PKHUD.sharedHUD.hide()
        }
    }
    
    func loadCategoryChildren(child: Dictionary<String, Any>) {
        let en_name: String = child["en_name"] as! String
        let url = "http://gank.io/api/xiandu/category/" + en_name
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    self.menus = dict["results"] as! Array
                    self.collectionView.reloadData()
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
}

extension FreeViewController: TopMenuScrollViewDelegate {
    func topMenuScrollView(_ scrollView: TopMenuScrollView, selectedIndex index: Int) {
//        addControllerView(index: index)
//        let x = self.scrollView.frame.size.width * CGFloat(index)
//        let point: CGPoint = CGPoint(x: x, y: self.scrollView.contentOffset.y)
//        self.scrollView.setContentOffset(point, animated: true)
    }
}

extension FreeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FreeMenuViewCell", for: indexPath) as? FreeMenuViewCell
        if(cell == nil) {
            let nib = Bundle.main.loadNibNamed("FreeMenuViewCell", owner: nil, options: nil)
            cell = nib?[0] as? FreeMenuViewCell
        }
        let dict:Dictionary = self.menus[indexPath.row] as! [String: Any]
        if let title = dict["title"] as? String {
            cell!.titleLabel.text = title
        }

        if dict.keys.contains("icon") {
            if let urlString:String = dict["icon"] as? String {
                cell!.imageView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image_default"))
            }
        }

        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
