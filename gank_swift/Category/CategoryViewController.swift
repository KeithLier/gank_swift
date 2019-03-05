//
//  CategoryViewController.swift
//  gank_swift
//
//  Created by keith on 2019/2/21.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    @IBOutlet weak var topScrollView: TopScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titles = ["社会","科技","娱乐","体育育","体育体育1","体育体育2","体育体育2","体育体育3"]
        topScrollView.delegate = self
        topScrollView.titles = titles
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CategoryViewController: TopScrollViewDelegate {
    func topScrollView(_ scrollView: TopScrollView, selectedIndex index: Int) {
        
    }
}
