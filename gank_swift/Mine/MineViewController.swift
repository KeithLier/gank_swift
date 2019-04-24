//
//  MIneViewController.swift
//  gank_swift
//
//  Created by keith on 2019/2/21.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit

class MineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var datas: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MineTableViewCell")
        self.datas = [
            [["title":"keith","subtitle":"干货账号","icon":"header"]],
            [["title":"支付","icon":"pay"]],
            [["title":"收藏","icon":"fav"],["title":"相册","icon":"photo"],["title":"卡包","icon":"card"],["title":"表情","icon":"face"],],
            [["title":"设置","icon":"setting"]],
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        self.tabBarController?.navigationItem.title = "我的"
        self.tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.setting))
        
    }

    @objc func setting() {
        
    }

}

extension MineViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.datas.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array: Array<Any> = self.datas[section] as! Array
        return array.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 100
        }
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MineTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MineTableViewCell")
        }
        
        let array: Array<Any> = self.datas[indexPath.section] as! Array
        let dict:Dictionary = array[indexPath.row] as! [String: Any]
        if let title = dict["title"] as? String {
            cell?.textLabel?.text = title
        }
        if let subtitle = dict["subtitle"] as? String {
            cell?.detailTextLabel?.text = subtitle
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
