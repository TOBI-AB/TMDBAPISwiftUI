//
//  Array+Extensions.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/25/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension Array where Element: Hashable & Equatable {
   
    // Difference
    func difference(from array: [Element]) -> [Element] {
        let rr = self.difference(from: array) { (elem1, elem2) -> Bool in
            elem1 != elem2
        }
        
        return self.applying(rr) ?? []
    }
    
    // Split To Slices
    func splitToSlices(slicesDimension dimension: Int) -> [[Element]] {
        var multiDimensionsArray = [[Element]]()
        
        if self.count.isMultiple(of: dimension) {
            
            _ = self.enumerated().forEach({ (offset, element) in
                
                if offset <= dimension, offset.isMultiple(of: dimension) {
                    multiDimensionsArray.append(Array(self[offset...(offset + (dimension - 1))]))
                } else if offset > dimension, offset.isMultiple(of: dimension) && offset < self.count - 1 {
                    multiDimensionsArray.append(Array(self[offset...(offset + (dimension - 1))]))
                }
            })
        } else {
            return [[]]
        }
        
        return multiDimensionsArray
    }
}
