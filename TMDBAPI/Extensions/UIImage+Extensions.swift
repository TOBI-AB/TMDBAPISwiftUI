//
//  UIImage+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 23/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI


extension UIImage {
    var averageColor: UIColor? {
        
        guard let inputImage = self.ciImage ?? CIImage(image: self) else { return nil }
        
        guard let averageFilter = CIFilter(name: "CIAreaAverage", parameters:
            [kCIInputImageKey: inputImage, kCIInputExtentKey: CIVector(cgRect: inputImage.extent)]) else { return nil }
    
        guard let outputImage = averageFilter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace : kCFNull])
        let outputImageRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: outputImageRect, format: .RGBA8, colorSpace: nil)
        
        let color = UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
        
        return color
    }
}
