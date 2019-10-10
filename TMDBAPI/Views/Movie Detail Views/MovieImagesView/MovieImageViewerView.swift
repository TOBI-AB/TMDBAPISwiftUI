//
//  MovieImageViewerView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 23/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct MovieImageViewerView: View {
    
    @Environment(\.presentationMode) var isPresented
    
    let selectedImage: (UIImage, CGFloat)
    
    var body: some View {
        NavigationView {
            Image(uiImage: selectedImage.0)
            .resizable()
            .aspectRatio(selectedImage.1, contentMode: .fit)
            //.padding(.horizontal, 1)
            .navigationBarTitle(Text(""), displayMode: .inline)
            .navigationBarItems(trailing: Button("Done") { self.isPresented.wrappedValue.dismiss() })
        }
    }
}
