//
//  String+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 30/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension String {
    var linesNumber: Int {
        self.split(separator: ",").count
    }
    
    var toCountryName: String {
        let countryName = NSLocale.current.localizedString(forRegionCode: self) ?? ""
        
        return countryName
    }
}
