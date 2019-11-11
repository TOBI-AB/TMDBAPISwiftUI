//
//  CollectionViw.swift
//  PlayAroundWithSwiftUI
//
//  Created by GhaffarMac on 10/26/19.
//  Copyright © 2019 GhaffarMac. All rights reserved.
//

import SwiftUI

enum ScrollDirection {
    case horizontal
    case vertical
}

class MoviessCollectionViewCoordinator: NSObject {
    var dataSource: UICollectionViewDiffableDataSource<Int, Movie>?
    var didSelectedMovie: ((Movie) -> ())?
    
}

extension MoviessCollectionViewCoordinator: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        guard let unwrappedDataSource = dataSource else { return }
        guard let selectedMovie = unwrappedDataSource.itemIdentifier(for: indexPath) else { return }
        
        didSelectedMovie?(selectedMovie)
    }
}


struct MoviessCollectionView: UIViewRepresentable {
 
   // @EnvironmentObject var fetcher: Fetcher
    let data: [Movie]
    @Binding var selectedMovie: Movie
    @Binding var selection: Int?
    let scrollDirection: ScrollDirection
    

    typealias UIViewType = UICollectionView
    
    func makeUIView(context: UIViewRepresentableContext<MoviessCollectionView>) -> UICollectionView {
        
        let layout = creatCompositionalLayout()
        layout.invalidateLayout()
                
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseIdentifier)
        collectionView.delegate = context.coordinator
                        
        let dataSource = UICollectionViewDiffableDataSource<Int, Movie>(collectionView: collectionView) { (collectionView, indexPath, model)  in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
                fatalError()
            }
            
            self.configure(cell: cell, with: model, for: indexPath)
            return cell
        }
        
        context.coordinator.dataSource = dataSource
        
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: UIViewRepresentableContext<MoviessCollectionView>) {
        guard let dataSource = context.coordinator.dataSource, !self.data.isEmpty else { return }
                        
        populate(uiView, dataSource: dataSource)
        
        context.coordinator.didSelectedMovie = { movie in
            self.selectedMovie = movie
            self.selection = 0
        }
    }
    
    func makeCoordinator() -> MoviessCollectionViewCoordinator {
        MoviessCollectionViewCoordinator()
    }
}

// MARK: - Collection view data source
extension MoviessCollectionView {
    
    fileprivate func configure(cell: CollectionViewCell, with model: Movie, for indexPath: IndexPath) {
        cell.configure(with: model)
    }
    
    fileprivate func populate(_ collectionView: UICollectionView,dataSource: UICollectionViewDiffableDataSource<Int, Movie>) {
        
        var snapShot = NSDiffableDataSourceSnapshot<Int, Movie>()
        
        if !data.isEmpty {//!fetcher.movies.isEmpty  {
                        
            snapShot.appendSections([0])
            snapShot.appendItems(self.data)//fetcher.movies)
            dataSource.apply(snapShot, animatingDifferences: true)
        } else {
            debugPrint("------- EMPTY -------")
        }
    }
}

// MARK: - Collection view Layout
extension MoviessCollectionView {
  
    fileprivate func creatCompositionalLayout() -> UICollectionViewLayout {
                
        let layoutDimension: NSCollectionLayoutDimension = (scrollDirection == .horizontal) ? .fractionalHeight(1) :  .fractionalHeight(1/3)
                
        let layout = UICollectionViewCompositionalLayout {(_, _) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 2.5, bottom: 5, trailing: 2.5)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: layoutDimension), subitem: item, count: (self.scrollDirection == .horizontal) ? 4 : 3)
            
            let section = NSCollectionLayoutSection(group: group)
            
            let sectionContentInsets: NSDirectionalEdgeInsets = (self.scrollDirection == ScrollDirection.horizontal) ? .init() : .init(top: 0, leading: 5, bottom: 0, trailing: 5)
            
            section.contentInsets =  sectionContentInsets
            section.orthogonalScrollingBehavior = (self.scrollDirection == ScrollDirection.horizontal) ? .continuousGroupLeadingBoundary : .none
            
            return section
        }
        
        return layout
    }
}
