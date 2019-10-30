//
//  Array+Extensions.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/25/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import Foundation

extension Array {
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
