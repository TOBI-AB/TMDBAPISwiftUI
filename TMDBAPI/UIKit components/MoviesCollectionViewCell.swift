//
//  CollectionViewCell.swift
//  PlayAroundWithSwiftUI
//
//  Created by GhaffarMac on 10/26/19.
//  Copyright © 2019 GhaffarMac. All rights reserved.
//

import SwiftUI
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    static var reuseIdentifier: String {
         self.description()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func configureSubviews() {
        
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray3.cgColor
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        imageView.sizeToFit()
        
        let stackView = UIStackView(arrangedSubviews: [imageView,nameLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.8),
        ])
    }
    
    func configure(with movie: Movie) {
        nameLabel.text = movie.title
        imageView.kf.setImage(with: TMDBAPI.imageResource(for: movie.posterPath))
    }
}
