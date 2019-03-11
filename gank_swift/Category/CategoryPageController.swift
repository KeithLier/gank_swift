//
//  CategoryPageController.swift
//  gank_swift
//
//  Created by keith on 2019/3/6.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire

class CategoryPageController: UIViewController {
    
    public var category: String = ""
    var results:Array<Any> = []
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "NewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewTableViewCell")
        
        loadData()
    }

    func loadData () {
        var url = "http://gank.io/api/data/";
        url = url + self.category + "/20/1";
        url = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    self.results = dict["results"] as! Array
                }
            }
            self.tableView.reloadData()
        }
    }
}

extension CategoryPageController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell") as! NewTableViewCell
        if(cell == nil) {
            let nib = Bundle.main.loadNibNamed("NewTableViewCell", owner: nil, options: nil)
            cell = nib?[0] as! NewTableViewCell
        }
        let dict:Dictionary = self.results[indexPath.row] as! [String: Any]
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
                    DispatchQueue.global().async {
                        let url: NSURL = NSURL(string: urlString)!
                        let data = NSData(contentsOf: url as URL)!
                        DispatchQueue.main.async {
                            cell.imgView.image = UIImage(data: data as Data, scale: 1.0)
                        }
                    }
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dict:Dictionary = self.results[indexPath.row] as! [String: Any]
        if let url = dict["url"] as? String {
            let webVC: WebViewController = WebViewController()
            webVC.url = url
            webVC.title = dict["who"] as? String
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
    }
}
