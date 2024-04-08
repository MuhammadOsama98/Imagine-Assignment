
import UIKit

class HomePage: BaseVC {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
      var viewModel  = HomePageViewModel()

    
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Assigning closures with capture lists to avoid retain cycles
        viewModel.apiResultUpdated = { [weak self] in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            self.tableView.reloadData()
        }
        
        // Start the indicator before fetching data
        indicator.startAnimating()
        viewModel.fetchTrending()
        
        // Set up observer for error message
        viewModel.errorOccurred = { [weak self] errorMessage in
            guard let self = self else { return }
            if let errorMessage = errorMessage {
                // Display error message
                self.showErrorAlert(message: errorMessage)
            }
        }
    }
 

    override func viewDidLoad() {
        super.viewDidLoad()

        //searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.setNavigationBar(title: "Home Page")
        setupTableView()

    }
    
    override func setNavigationBar(title: String?) {
        navigationItem.title = title ?? ""
        navigationItem.titleView?.tintColor = .white
        

      let backButton  = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        backButton.tintColor = .black
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action:#selector(backFuncs), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
                
    showSearchBarButton(shouldShow: true)

    }
    
    @objc override func backFuncs() {
        viewModel.homePageCoordinator?.toFavoriteScreen()

    }

}

extension HomePage: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.count > 1{
                DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(500)) {
                    if !self.indicator.isAnimating{
                        self.indicator.startAnimating()
                    }
                    self.viewModel.searchGif(query: searchText)
                }
            }else{
                if !indicator.isAnimating{
                    indicator.startAnimating()
                }
                self.viewModel.fetchTrending()
            }
     }
       
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      
      self.search(shouldShow: false)

      self.searchBar.text = ""
      self.viewModel.fetchTrending()
      self.tableView.reloadData()
           


       }
    
    

       
    }




extension HomePage : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.searchResults.count
    }
    
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HomePageTableViewCell.reuseID, for: indexPath) as! HomePageTableViewCell
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
    
                let item = self.viewModel.searchResults[indexPath.row]
    
        cell.setupUI()
        cell.setData(searchResult: item)
    
            cell.buttonAction = {
                
            if cell.isFavorite {
                
                
                self.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", actionTitle: "Delete", cancelTitle: "Cancel", actionHandler: {
                    
                    
                    RealmControl.shared.deleteFavorite(id: item.id)
                    let image = UIImage(systemName: "heart")
                cell.btnFavorite.setImage(image, for: .normal)
                cell.isFavorite = false
                })

                
            }else{
                
                RealmControl.shared.addFavorite(searchResultss: item)
                let image = UIImage(systemName: "heart.fill")
                cell.btnFavorite.setImage(image, for: .normal)
                cell.isFavorite = true
            }
        
}
    
            return cell
}
    
  
func setupTableView(){
        
        tableView.register(HomePageTableViewCell.self, forCellReuseIdentifier:HomePageTableViewCell.reuseID)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = UITableView.automaticDimension

}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.goToItemDetails(gifId: self.viewModel.searchResults[indexPath.row].id)
    }

}




