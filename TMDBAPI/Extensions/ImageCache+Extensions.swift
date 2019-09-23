//
//  ImageCache+Extensions.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 23/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI
import Kingfisher

extension ImageCache {
    func getImage(for movieImage: MovieImage) {
        ImageCache.default.retrieveImage(forKey: movieImage.filePath) { res in
            do {
                let img = try res.get().image
                                
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: NSNotification.Name.DidSelectImage,
                                                    object: (img, CGFloat(movieImage.aspectRatio)))
                }
                
            } catch {
                debugPrint("Error getting cached image: \(error)")
            }
        }
    }
}
