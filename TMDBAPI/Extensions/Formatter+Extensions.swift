//
//  Formatter+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 31/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension DateComponentsFormatter {
    static var timeFormatter: DateComponentsFormatter {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .brief
        
        return formatter
    }
}

extension NumberFormatter {
    
    static var golbalFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en_US")//Locale.current
        
        return numberFormatter
    }
    
    static var threeDigitsFormatter: NumberFormatter {
        let numb = NumberFormatter.golbalFormatter
        numb.numberStyle = .decimal
        numb.maximumFractionDigits = 3
        
        return numb
    }
}
