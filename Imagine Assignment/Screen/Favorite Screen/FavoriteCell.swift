//
//  FavoriteCell.swift
//  Imagine Assignment
//
//  Created by Pillars Fintech on 06/04/2024.
//

import UIKit

class FavoriteCell: UICollectionViewCell {
    
    var buttonAction: (() -> Void)?

    static let reuseID = "FavoriteCell"
    

    lazy var contentViews:CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.cornerRadius = 10
        view.shadowColor = .black
        view.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view

    }()

    
  private lazy var imageViewItem = {
        let uiImageViews = UIImageView()
        let image = UIImage(named: "placeholder")
        uiImageViews.image = image
        uiImageViews.translatesAutoresizingMaskIntoConstraints = false
        uiImageViews.clipsToBounds = true
        uiImageViews.layer.cornerRadius = 10
        uiImageViews.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return uiImageViews
    }()
    
    
    
    private lazy var titleLabel:UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Title"
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 13, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    
    private lazy var descriptionLabel:UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = ""
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 11, weight: .regular)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    
    lazy var favoriteBtnViews:CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.cornerRadius = 10
        view.shadowColor = .black
        view.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view

    }()

    
     lazy var btnFavorite = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnFavoriteTapped), for: .touchUpInside)
        return button
        
    }()
    
    var searchResultss:SearchResult?
    
    var searchResultRealm:SearchResultRealm?

    
    @objc func btnFavoriteTapped(){
        buttonAction?()
    }
    
    
    func setupUI() {
        contentView.addSubview(contentViews)
        contentViews.addSubviews(imageViewItem, titleLabel, favoriteBtnViews)
        favoriteBtnViews.addSubview(btnFavorite)
        
        // Disable translatesAutoresizingMaskIntoConstraints for all subviews
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentViews.translatesAutoresizingMaskIntoConstraints = false
        imageViewItem.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteBtnViews.translatesAutoresizingMaskIntoConstraints = false
        btnFavorite.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints
        
        // ContentViews constraints
        NSLayoutConstraint.activate([
            contentViews.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            contentViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            contentViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            contentViews.heightAnchor.constraint(equalToConstant: 240) ,// Set your desired height
            contentViews.widthAnchor.constraint(equalToConstant: 170) ,// Set your desired height

        ])
        
        // ImageView constraints
        NSLayoutConstraint.activate([
            imageViewItem.topAnchor.constraint(equalTo: contentViews.topAnchor,constant: 0),
            imageViewItem.leadingAnchor.constraint(equalTo: contentViews.leadingAnchor,constant: 0),
            imageViewItem.trailingAnchor.constraint(equalTo: contentViews.trailingAnchor,constant: 0),
            imageViewItem.heightAnchor.constraint(equalToConstant: 120) // Set your desired height
        ])
        
        // Title Label constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageViewItem.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentViews.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentViews.trailingAnchor, constant: -10)
        ])
        

        
        // Favorite Button View constraints
        NSLayoutConstraint.activate([
            favoriteBtnViews.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            favoriteBtnViews.trailingAnchor.constraint(equalTo: contentViews.trailingAnchor, constant: -10),
            favoriteBtnViews.bottomAnchor.constraint(equalTo: contentViews.bottomAnchor, constant: -10),
            favoriteBtnViews.widthAnchor.constraint(equalToConstant: 50),
            favoriteBtnViews.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Favorite Button constraints
        NSLayoutConstraint.activate([
            btnFavorite.topAnchor.constraint(equalTo: favoriteBtnViews.topAnchor, constant: 10),
            btnFavorite.leadingAnchor.constraint(equalTo: favoriteBtnViews.leadingAnchor, constant: 10),
            btnFavorite.trailingAnchor.constraint(equalTo: favoriteBtnViews.trailingAnchor, constant: -10),
            btnFavorite.bottomAnchor.constraint(equalTo: favoriteBtnViews.bottomAnchor, constant: -10)
        ])
    }

    func setData(searchResult:SearchResultRealm){
        self.titleLabel.text = searchResult.title
        let url = URL(string: searchResult.images)
        self.imageViewItem.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"))
        self.descriptionLabel.text = searchResult.user
        
        
        if searchResult.isFavorite ?? false {
            let image = UIImage(systemName: "heart.fill")
            btnFavorite.setImage(image, for: .normal)
        }else{
            let image = UIImage(systemName: "heart")
            btnFavorite.setImage(image, for: .normal)
            btnFavorite.tintColor = .brown
        }
    }


    
    
}
