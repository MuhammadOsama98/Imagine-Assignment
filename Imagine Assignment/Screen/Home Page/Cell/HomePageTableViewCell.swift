import UIKit
import Kingfisher

class HomePageTableViewCell: UITableViewCell {
    
    static let reuseID = "homePageTableViewCell"
    
    var isFavorite: Bool = false {
        didSet {
            let imageName = isFavorite ? "heart.fill" : "heart"
            let image = UIImage(systemName: imageName)
            btnFavorite.setImage(image, for: .normal)
        }
    }
    


    
    var buttonAction: (() -> Void)?
    
    lazy var contentViews: CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.cornerRadius = 10
        view.shadowColor = .black
        view.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageViewItem: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var favoriteBtnViews: CardView = {
        let view = CardView()
        view.backgroundColor = .white
        view.cornerRadius = 10
        view.shadowColor = .black
        view.shadowOpacity = 0.3
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var btnFavorite: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(btnFavoriteTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func btnFavoriteTapped() {
        buttonAction?()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        contentView.addSubview(contentViews)
        contentViews.addSubviews(imageViewItem, titleLabel, descriptionLabel, favoriteBtnViews)
        favoriteBtnViews.addSubview(btnFavorite)
        
        
        
        NSLayoutConstraint.activate([
            // Card view
            contentViews.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            contentViews.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            contentViews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            contentViews.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            // Image view
            imageViewItem.leadingAnchor.constraint(equalTo: contentViews.leadingAnchor),
            imageViewItem.topAnchor.constraint(equalTo: contentViews.topAnchor),
            imageViewItem.trailingAnchor.constraint(equalTo: contentViews.trailingAnchor),

            
            // Title label
            titleLabel.topAnchor.constraint(equalTo: imageViewItem.bottomAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentViews.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentViews.trailingAnchor, constant: -20),
            
            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentViews.leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentViews.trailingAnchor, constant: -20),
            
            // Favorite button views
            favoriteBtnViews.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            favoriteBtnViews.trailingAnchor.constraint(equalTo: contentViews.trailingAnchor, constant: -10),
            favoriteBtnViews.bottomAnchor.constraint(equalTo: contentViews.bottomAnchor, constant: -15),

            // Favorite button
            btnFavorite.centerXAnchor.constraint(equalTo: favoriteBtnViews.centerXAnchor),
            btnFavorite.centerYAnchor.constraint(equalTo: favoriteBtnViews.centerYAnchor),
        ])
        

        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Adjust UI for iPad
            
            titleLabel.font = .systemFont(ofSize: 27, weight: .bold)
            descriptionLabel.font = .systemFont(ofSize: 25, weight: .light)
            favoriteBtnViews.cornerRadius = 7


            
            NSLayoutConstraint.activate([
                imageViewItem.heightAnchor.constraint(equalToConstant: 500),
                favoriteBtnViews.widthAnchor.constraint(equalToConstant: 70),
                favoriteBtnViews.heightAnchor.constraint(equalToConstant: 70),
                btnFavorite.widthAnchor.constraint(equalToConstant: 50),
                btnFavorite.heightAnchor.constraint(equalToConstant: 50),
            ])

            
        }else{
            // Common UI settings
            titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
            descriptionLabel.font = .systemFont(ofSize: 15, weight: .light)
            favoriteBtnViews.cornerRadius = 7
   
            NSLayoutConstraint.activate([
                imageViewItem.heightAnchor.constraint(equalToConstant: 190),
                favoriteBtnViews.widthAnchor.constraint(equalToConstant: 40),
                favoriteBtnViews.heightAnchor.constraint(equalToConstant: 40),
                btnFavorite.widthAnchor.constraint(equalToConstant: 24),
                btnFavorite.heightAnchor.constraint(equalToConstant: 24),

            ])
        }
        
        
        
        
    }

    func setData(searchResult: SearchResult) {
        titleLabel.text = searchResult.title
        let url = URL(string: searchResult.images.downsized.url)
        imageViewItem.kf.setImage(with: url, placeholder: UIImage(named: "placeholder"))
        descriptionLabel.text = searchResult.user?.description
        
        
        let roomID = RealmControl.shared.getDataID(id: searchResult.id)
        
        if (roomID.id == searchResult.id) {
            self.isFavorite = true
        }else{
            self.isFavorite = false

        }
    
    
    }
}

