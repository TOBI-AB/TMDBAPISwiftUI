//
//  Jsondecoder+Extensions.swift
//  TMDBAPI
//
//  Created by GhaffMac on 28/08/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension JSONDecoder {
    
    static var decoder: JSONDecoder {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .convertFromSnakeCase
        
        let formatter = DateFormatter()
        formatter.dateFormat = "y-MM-d"
        dec.dateDecodingStrategy = .formatted(formatter)
        
        return dec
    }
}
