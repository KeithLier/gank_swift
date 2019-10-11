//
//  DatePickerViewController.swift
//  gank_swift
//
//  Created by keith on 2019/3/1.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit

typealias chooseDate = (String) -> ()

class DatePickerViewController: UIViewController {

    var chooseDate: chooseDate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        self.view.addGestureRecognizer(tap);
    
        self.datePicker.addTarget(self, action: #selector(self.datePickerChanged), for: .valueChanged)
        // Do any additional setup after loading the view.
    }

    @IBAction func confirm(_ sender: Any) {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let date: String = formatter.string(from: datePicker.date)
        chooseDate!(date)
        
        self.hide()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.hide()
    }

    @objc func hide() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func datePickerChanged(_ sender: UIDatePicker ) {
//        let formatter: DateFormatter = DateFormatter()
//        formatter.dateFormat = "yyyyMMdd"
//        let date: String = formatter.string(from: sender.date)
//        chooseDate!(date)
    }
}
