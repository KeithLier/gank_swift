//
//  HistoryViewController.swift
//  gank_swift
//
//  Created by keith on 2019/10/22.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

typealias selectedDate = (String) -> ()

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var allHistories:Array<String> = []
    var histories:Array<String> = []
    var selectedDate: selectedDate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "historyTableViewCell")
        self.loadData()
        
        // Do any additional setup after loading the view.
    }

    func loadData () {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        PKHUD.sharedHUD.show(onView: self.view)
        let url = "http://gank.io/api/day/history"
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    let arr: NSMutableArray =  []
                    arr.addObjects(from: dict["results"] as! Array)
                    arr.insert(self.getToday(), at: 0)
                    self.allHistories = arr as! Array<String>
                    self.histories = arr as! Array<String>
                }
            }
            PKHUD.sharedHUD.hide()
            self.tableView.reloadData()
        }
    }
    
    func getToday() -> String {
        let date = Date()
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: date)
        return today
    }

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.histories.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "historyTableViewCell")
        }
        let date = self.histories[indexPath.row]
        cell?.textLabel?.text = date
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let text = self.histories[indexPath.row]
        let dates: [String] = text.components(separatedBy: "-")
        let date = dates.joined(separator: "/")
        selectedDate!(date)
        self.navigationController?.popViewController(animated: true)
    }
}

extension HistoryViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchDate(text: searchBar.text!)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchDate(text: searchText)
    }
    
    func searchDate(text: String) {
        if text == "" {
            self.histories = self.allHistories
        } else {
            let arr: NSMutableArray = []
            for date in self.allHistories {
                if date.contains(text) {
                    arr.add(date)
                }
            }
            self.histories = arr as! Array<String>
        }
        self.tableView.reloadData()
    }
}

