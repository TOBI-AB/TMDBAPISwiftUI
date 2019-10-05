//
//  PickerView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 04/10/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct PickerView: View {
    @Binding var selection: Int
    let data: [String]
    let title = ""
    
    var body: some View {
        
        Picker(selection: self.$selection, label: Text(title)) {
            ForEach(data, id: \.self) { element in
                Text(element).tag(self.data.indexOfElement(element))
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

