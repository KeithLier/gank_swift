//
//  CategoryPageController.swift
//  gank_swift
//
//  Created by keith on 2019/3/6.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class CategoryPageController: UIViewController {
    
    public var category: String = ""
    var results:NSMutableArray = []
    var pageNumber: Int = 1
    @IBOutlet weak var tableView: UITableView!
    
    let header = MJRefreshNormalHeader()
    let footer = MJRefreshAutoNormalFooter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "NewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewTableViewCell")
        self.tableView.register(UINib(nibName: "ImageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ImageTableViewCell")
        header.setRefreshingTarget(self, refreshingAction: #selector(refreshData))
        footer.setRefreshingTarget(self, refreshingAction: #selector(loadMoreData))
        self.tableView.mj_header = header
        self.tableView.mj_footer = footer
        header.beginRefreshing()
    }

    @objc func refreshData() {
        pageNumber = 1
        loadData()
    }
    
    @objc func loadMoreData() {
        pageNumber += 1
        loadData()
    }
    
    func loadData () {
        var url = "http://gank.io/api/data/";
        url = url + self.category + "/20/" + String(pageNumber);
        url = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        Alamofire.request(url).responseJSON { response in
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    if (dict["error"]?.boolValue)! {
                        return
                    }
                    if self.pageNumber == 1 {
                        self.results.removeAllObjects()
                    }
                    let results:Array<Any> = dict["results"] as! Array
                    if results.count == 0 {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                    self.results.addObjects(from: results)
                }
            }
            self.tableView.reloadData()
        }
    }
}

extension CategoryPageController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.category == "福利" {
            return tableView.frame.width
        }

        return 100;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict:Dictionary = self.results[indexPath.row] as! [String: Any]
        if self.category == "福利" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
            if(cell == nil) {
                let nib = Bundle.main.loadNibNamed("ImageTableViewCell", owner: nil, options: nil)
                cell = nib?[0] as! ImageTableViewCell
            }
            if let date = dict["publishedAt"] as? String {
                cell.dateLabel.text = date
            }
            if let urlString = dict["url"] as? String {
                cell.imgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image_default"))
            }
            return cell
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell") as! NewTableViewCell
        if(cell == nil) {
            let nib = Bundle.main.loadNibNamed("NewTableViewCell", owner: nil, options: nil)
            cell = nib?[0] as! NewTableViewCell
        }
        if let title = dict["desc"] as? String {
            cell.titleLabel.text = title
        }
        if let who = dict["who"] as? String {
            cell.autherLabel.text = who
        }
        if let date = dict["publishedAt"] as? String {
            cell.dateLabel.text = date
        }
        if dict.keys.contains("images") {
            if let images:Array<String> = dict["images"] as? [String] {
                if let urlString = images.first {
                    cell.imgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image_default"))
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.category == "福利" {
            return
        }

        let dict:Dictionary = self.results[indexPath.row] as! [String: Any]
        if let url = dict["url"] as? String {
            let webVC: WebViewController = WebViewController()
            webVC.url = url
            webVC.title = dict["who"] as? String
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
    }
}
