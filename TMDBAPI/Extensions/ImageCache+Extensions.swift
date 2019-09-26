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
    func notifyImageSelection(for movieImage: MovieImage, notificationName: Notification.Name) {
                
        ImageCache.default.retrieveImage(forKey: movieImage.filePath) { res in
            switch res {
            case .success(let res):
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: notificationName,
                                                    object: (res.image, CGFloat(movieImage.aspectRatio)))
                }
            case .failure(let error):
                debugPrint("Error getting image from cache: \(error.errorDescription ?? "")")
            }
        }
    }
}
