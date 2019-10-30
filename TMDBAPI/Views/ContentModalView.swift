//
//  ContentModalView.swift
//  TMDBAPI
//
//  Created by GhaffarMac on 10/8/19.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct ContentModalView: View {
    
    let title: String
    let content: String
    @Binding var isContentViewPresented: Bool
    
    var body: some View {
        NavigationView {
            TextView(text: self.content)
                .padding()
                .navigationBarTitle(Text(verbatim: "\(self.title)"), displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(action: { self.isContentViewPresented = false }, label: {
                        Text("Done")
                    })
            )
        }
    }
}
