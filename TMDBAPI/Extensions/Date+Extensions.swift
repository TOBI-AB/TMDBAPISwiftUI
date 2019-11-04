//
//  Date+Extensions.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/16/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension Date {
    
    func getComponents(_ components: Set<Calendar.Component>) -> String {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents(components, from: self)
        
        if let year = dateComponents.year {
            return String(year)
        }
        
        return ""
    }
}
