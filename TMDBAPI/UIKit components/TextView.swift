//
//  TextView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 04/10/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UITextView(frame: .zero)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
        
    }
    
    
    
}
