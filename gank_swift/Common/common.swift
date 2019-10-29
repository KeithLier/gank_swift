//
//  common.swift
//  gank_swift
//
//  Created by keith on 2019/10/24.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit

extension String {
    
    public func dateFormatter(date: String) -> String {
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
