//
//  GridView.swift
//  TMDBAPI
//
//  Created by Ghaff Ett on 02/09/2019.
//  Copyright © 2019 GhaffMac. All rights reserved.
//

import SwiftUI

struct GridView<Data, Content>: View where Data: RandomAccessCollection, Content: View, Data.Element: Identifiable {
    
    private struct GridIndex: Identifiable { var id: Int }
    
    private let columns: Int
 //   private let columnsInLandscape: Int
    private let vSpacing: CGFloat
    private let hSpacing: CGFloat
    private let vPadding: CGFloat
    private let hPadding: CGFloat
    
    private let data: [Data.Element]
    private let content: (Data.Element) -> Content
    
    
    init(_ data: Data,
                columns: Int,
                vSpacing: CGFloat = 10,
                hSpacing: CGFloat = 10,
                vPadding: CGFloat = 10,
                hPadding: CGFloat = 10,
                content: @escaping (Data.Element) -> Content) {
      self.data = data.map { $0 }
      self.content = content
      self.columns = max(1, columns)
      self.vSpacing = vSpacing
      self.hSpacing = hSpacing
      self.vPadding = vPadding
      self.hPadding = hPadding
    }
    
    private var rows: Int {
        data.count / self.columns
    }
    
    var body: some View {
        GeometryReader { g in
            ScrollView(showsIndicators: false) {
                VStack(spacing: self.vSpacing) {
                    ForEach((0..<self.rows).map { GridIndex(id: $0) }) { row in
                        self.rowAtIndex(row.id, geometry: g)
                    }
                    
                    // Handle last row
                    if (self.data.count % self.columns > 0) {
                        self.rowAtIndex(self.columns * self.rows, geometry: g, isLastRow: true)
                    }
                }
            }
        }
    }
    
    private func rowAtIndex(_ index: Int, geometry: GeometryProxy, isLastRow: Bool = false) -> some View {
        
        HStack(spacing: self.hSpacing) {
            ForEach((0..<(isLastRow ? data.count % columns : columns)).map { GridIndex(id: $0) }) { column in
                self.content(self.data[index + column.id])
                    .frame(width: self.contentWidthFor(geometry))
            }
            if isLastRow { Spacer() }
        }
    }
    
    private func contentWidthFor(_ geometry: GeometryProxy) -> CGFloat {
        let hSpacings = hSpacing * (CGFloat(self.columns) - 1)
        let width = geometry.size.width - hSpacings - hPadding * 2
        
        return width / CGFloat(self.columns)
    }
}
