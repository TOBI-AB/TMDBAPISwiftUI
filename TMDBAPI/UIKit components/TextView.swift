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
    
    let text: String
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UITextView(frame: .zero)
        textView.backgroundColor = .systemBackground
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
        
        uiView.isEditable = false
        
        guard let attributes = self.text.attributes().mutableCopy() as? NSMutableAttributedString else {
            return
        }
        
        let range = NSRange(location: 0, length: self.text.utf16.count)
        
        attributes.addAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], range: range)
        attributes.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.label], range: range)
        
        uiView.attributedText = attributes
    }
}
