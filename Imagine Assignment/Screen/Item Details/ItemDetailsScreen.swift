
import UIKit
import Kingfisher

class ItemDetailsScreen: BaseVC {
    
    @IBOutlet weak var iVIremDetails: UIImageView!
    
    @IBOutlet weak var itemDetailsTitle: UILabel!
    
    @IBOutlet weak var itemDetailsDescription: UILabel!
    
    
    @IBOutlet weak var controlViewDescription: UIView!
    
    
    @IBOutlet weak var itemDetailsType: UILabel!
    
    @IBOutlet weak var itemDetailsSlug: UILabel!
    
    
    @IBOutlet weak var itemDetailsUrlBtn: UIButton!
    
    
    
    
    @IBOutlet weak var ivFavorite: UIImageView!
    
    
    
    @IBOutlet weak var btnFavorite: UIButton!
    
    
    var isFavorite = false
    
    
    var viewModel  = ItemDetailViewModel()

    
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated:true)
        
        //"Item Details Screen"
        
        
        self.setNavigationBar(title: "Item Details")
        
        setupViewModel()
        setupUI()
        setUpipad()

        
        
    }
    
    private func setUpipad(){
        
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            // Adjust UI for iPad
            itemDetailsTitle.font = .systemFont(ofSize: 29, weight: .bold)
            itemDetailsDescription.font = .systemFont(ofSize: 26, weight: .regular)
            itemDetailsType.font = .systemFont(ofSize: 27, weight: .bold)

        }
        
        
    }

    
    private func setupViewModel() {
        viewModel.apiResultUpdated = { [weak self] in
            DispatchQueue.main.async {
                guard let self = self, let gifDetails = self.viewModel.gifDetails else { return }
                
                if let url = URL(string: gifDetails.images.downsized.url) {
                    self.iVIremDetails.kf.setImage(with: url) { _ in
                        self.indicator.stopAnimating()
                    }
                }
                self.itemDetailsTitle.text = gifDetails.title
                self.itemDetailsDescription.text = gifDetails.user?.description
                self.itemDetailsType.text = gifDetails.type
                self.itemDetailsSlug.text = "Slug: \(gifDetails.slug)"
                self.ivFavorite.image = UIImage(systemName: self.isFavorite ? "heart.fill" : "heart")
            }
        }
    }
    
    
    private func setupUI() {
            btnFavorite.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
             itemDetailsUrlBtn.addTarget(self, action: #selector(openUrlTapped), for: .touchUpInside)
           
                guard let gifId = viewModel.gifId else{
                    return
                }
           
           indicator.startAnimating()
           viewModel.fetchGifDetails()
           
           viewModel.errorOccurred = { [weak self] errorMessage in
               guard let self = self, let errorMessage = errorMessage else { return }
               self.showErrorAlert(message: errorMessage)
           }
           
        
        let idItem = RealmControl.shared.getDataID(id: gifId)
        
        
        if viewModel.gifId ?? "" == idItem.id {
            self.isFavorite = true
        }else{
            self.isFavorite = false

        }
        

       }
    
    
    
    @objc func openUrlTapped(){
        openURL(self.viewModel.gifDetails?.url ?? "")
    }
    
    
    @objc func favoriteButtonTapped(){
        
        print(isFavorite)
        

        guard let searchResults = viewModel.gifDetails else{
            return
        }
        
    

        if self.isFavorite   {
            
            self.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", actionTitle: "Delete", cancelTitle: "Cancel", actionHandler: {
                RealmControl.shared.deleteFavorite(id: searchResults.id)
                self.ivFavorite.image = UIImage(systemName: "heart")
                self.isFavorite = false

            })
            
        }else{
            RealmControl.shared.addFavorite(searchResultss:searchResults)
            self.ivFavorite.image = UIImage(systemName: "heart.fill")
            self.isFavorite = true
        }

    }
    
    
    override func setNavigationBar(title: String?) {
        navigationItem.title = title ?? ""
        navigationItem.titleView?.tintColor = .white
        
      let backButton  = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action:#selector(backFuncs), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton) // Add backButton to navigationItem

    }
    
    @objc override func backFuncs() {
        
        if viewModel.itemDetailCoordinator?.from == "FavoriteItem"{
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.viewModel.backFavoriteItem()
            })
            
            
        }else{
            viewModel.BackHome()
        }
        
        


    }



}
