//
//  Collection+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 04/10/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension Collection where Element: Equatable {
  
    func indexOfElement(_ element: Element) -> Int {
        
        guard let index = self.firstIndex(where: { $0 == element }) as? Int else {
            return .init()
        }
        
        return index
    }
}
