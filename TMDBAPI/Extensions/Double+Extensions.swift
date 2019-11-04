//
//  Double+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension Double {
    var toString: String {
        NumberFormatter.threeDigitsFormatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var toTime: String {
        DateComponentsFormatter.timeFormatter.string(from: self * 60) ?? ""
    }
    
    var toPercent: String? {
        let num = NumberFormatter.golbalFormatter
        num.numberStyle = .percent
        return num.string(from: NSNumber(value: self))
    }
    
    var toCurrency: String {
        let num = NumberFormatter.golbalFormatter
        num.locale = Locale(identifier: "en-US")
        num.numberStyle = .currency
        num.maximumFractionDigits = 2
        num.decimalSeparator = "."
        return num.string(from: NSNumber(value: self)) ?? ""
    }
}



class DateManager {
    
    static let relativeFormatter = RelativeDateTimeFormatter()
    
   
    
    private static var dateFormatter: DateFormatter = {
       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
    
    static func formate(_ date: String) -> String {
            
        guard let date = dateFormatter.date(from: date) else {
            return ""
        }
                
        return  dateFormatter.string(from: date)//relativeFormatter.localizedString(for: dateAgoStr, relativeTo: Date())
    }
}
