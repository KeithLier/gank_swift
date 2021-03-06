//
//  NewViewController.swift
//  gank_swift
//
//  Created by keith on 2019/2/21.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import PKHUD
import MJRefresh

class NewViewController: UIViewController {
    
    var category:Array<String> = []
    var results:Dictionary<String, AnyObject> = [:]
    var dateString: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "NewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewTableViewCell")
        self.tableView.register(UINib(nibName: "ImageTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ImageTableViewCell")
        let mjHeader = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewData))
        self.tableView.mj_header = mjHeader
        
        self.dateString = self.getToday()

        loadNewData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)

        self.tabBarController?.navigationItem.title = "每日干货"
        self.reloadDateString()
    }
    
    func reloadDateString() {
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: self.dateString, style: .plain, target: self, action: #selector(self.selectHistory))
    }
    
    @objc func loadNewData() {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show(onView: self.view)
        var url = "http://gank.io/api/day/" + self.dateString
        if self.dateString == self.getToday() {
            url = "http://gank.io/api/today"
        }
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    self.category = dict["category"] as! Array
                    self.results = dict["results"] as! Dictionary<String, AnyObject>
                }
            }
            self.tableView.mj_header.endRefreshing()
            PKHUD.sharedHUD.hide()
            self.tableView.reloadData()
        }
    }
    
    @objc func chooseDate() {
        let date: DatePickerViewController = DatePickerViewController()
        date.chooseDate = { (date) -> () in
            self.dateString = date
            self.reloadDateString()
            self.loadNewData()
        }
        self.navigationController?.present(date, animated: true, completion: nil)
    }
    
    @objc func selectHistory() {
        let history: HistoryViewController = HistoryViewController()
        history.selectedDate = { (date) -> () in
            self.dateString = date
            self.reloadDateString()
            self.loadNewData()
        }
        self.navigationController?.pushViewController(history, animated: true)
    }
    
    func getToday() -> String {
        let date = Date()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let today = formatter.string(from: date)
        return today
    }
}

extension NewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let title = self.category[indexPath.section]
        if title == "福利" {
            return tableView.frame.width
        }
        return 100;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.category.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.category[section]
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = self.category[section]
        let news: Array<AnyObject> = self.results[title] as! Array
        return news.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = self.category[indexPath.section]
        let news: Array<AnyObject> = self.results[key] as! Array
        let dict:Dictionary = news[indexPath.row] as! [String: Any]
        if key == "福利" {
            var cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as? ImageTableViewCell
            if(cell == nil) {
                let nib = Bundle.main.loadNibNamed("ImageTableViewCell", owner: nil, options: nil)
                cell = nib?[0] as? ImageTableViewCell
            }
            if let date = dict["publishedAt"] as? String {
                cell!.dateLabel.text = date
            }
            if let urlString = dict["url"] as? String {
                cell!.imgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image_default"))
            }
            return cell!
        }
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell") as? NewTableViewCell
        if(cell == nil) {
            let nib = Bundle.main.loadNibNamed("NewTableViewCell", owner: nil, options: nil)
            cell = nib?[0] as? NewTableViewCell
        }
        if let title = dict["desc"] as? String {
            cell!.titleLabel.text = title
        }
        if let who = dict["who"] as? String {
            cell!.autherLabel.text = who
        }
        if let date = dict["publishedAt"] as? String {
            cell!.dateLabel.text = self.dateFormatter(date: date)
        }
        if dict.keys.contains("images") {
            if let images:Array<String> = dict["images"] as? [String] {
                if let urlString = images.first {
                    cell!.imgView.sd_setImage(with: URL(string: urlString), placeholderImage: UIImage(named: "no_image_default"))
                }
            }
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let key = self.category[indexPath.section]
        if key == "福利" {
            return
        }

        let news: Array<AnyObject> = self.results[key] as! Array
        let dict:Dictionary = news[indexPath.row] as! [String: Any]
        if let url = dict["url"] as? String {
            let webVC: WebViewController = WebViewController()
            webVC.url = url
            webVC.title = dict["who"] as? String
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func dateFormatter(date: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        formatter.timeZone = NSTimeZone.local
        let d: Date? = formatter.date(from: date)
        if d == nil {
            return date
        }
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: d!)
    }
}
