//
//  FreePageViewController.swift
//  gank_swift
//
//  Created by keith on 2019/10/29.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import PKHUD

class FreePageViewController: UIViewController {

    public var category: String = ""
    var menus: Array<AnyObject> = [] as Array<AnyObject>
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UINib(nibName: "FreeMenuViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "FreeMenuViewCell")
        
        self.loadCategoryChildren()
        // Do any additional setup after loading the view.
    }

    func loadCategoryChildren() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show(onView: self.view)
        let url = "http://gank.io/api/xiandu/category/" + self.category
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    self.menus = dict["results"] as! Array
                    self.collectionView.reloadData()
                }
            }
            PKHUD.sharedHUD.hide()
        }
    }
}

extension FreePageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = 80
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10;
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
        let dict:Dictionary = self.menus[indexPath.row] as! [String: Any]
        let free: FreePageListViewController = FreePageListViewController()
        free.category = dict["id"] as! String
        free.title = dict["title"] as? String
        self.navigationController?.pushViewController(free, animated: true)
    }
}
