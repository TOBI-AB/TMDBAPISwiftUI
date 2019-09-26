//
//  UIColor+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 23/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

extension UIColor {
    fileprivate var luminosity: CGFloat {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 0.0
        var white: CGFloat = 0.0
        
        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return 0.2126 * pow(red, 2.2) + 0.7152 * pow(green, 2.2) + 0.0722 * pow(blue, 2.2)
        } else if getWhite(&white, alpha: &alpha) {
            return pow(white, 2.2)
        }
        
        return -1
    }
    
    fileprivate func luminosityDifference(_ otherColor: UIColor) -> CGFloat {
        let first = luminosity
        let second = otherColor.luminosity
        
        if first >= 0, second >= 0 {
            if first > second {
                return (first + 0.05) / (second + 0.05)
            } else {
                return (second + 0.05) / (first + 0.05)
            }
        }
        
        return 0.0
    }
    
    static func basedOnBackgroundColor(_ backgroundColor: UIColor) -> UIColor {
        let lightColor = UIColor.lightText
        let lightDifference = backgroundColor.luminosityDifference(lightColor)
        
        let darkColor = UIColor.darkText
        let darkDifference = backgroundColor.luminosityDifference(darkColor)
        
        return darkDifference > lightDifference ? darkColor : lightColor
    }
}
