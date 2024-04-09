
import UIKit
import Combine

class HomePage: BaseVC {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var viewModel  = HomePageViewModel()

    // Flag to prevent multiple requests
    var isFetching = false

    // For Combine subscriptions
    var cancellables = Set<AnyCancellable>()

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateBadgeValue()
        tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
 


    override func viewDidLoad() {
        super.viewDidLoad()

        //searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        self.setNavigationBar(title: "Home Page")
        setupTableView()
        setupViewModelBindings()
        fetchDataIfNeeded()

    }
    

    
    private func setupViewModelBindings() {
        viewModel.apiResultUpdated = { [weak self] in
            guard let self = self else { return }
            self.handleDataUpdate()
        }
        
        viewModel.errorOccurred = { [weak self] errorMessage in
            guard let self = self else { return }
            self.handleError(errorMessage)
        }
    }
        
    private func fetchDataIfNeeded() {
        if !isFetching {
            isFetching = true
            indicator.startAnimating()
            viewModel.fetchTrending()
        }
    }
    
    private func handleDataUpdate() {
        indicator.stopAnimating()
        tableView.reloadData()
        isFetching = false
    }
    
    private func handleError(_ errorMessage: String?) {
        indicator.stopAnimating()
        if let errorMessage = errorMessage {
            showErrorAlert(message: errorMessage)
        }
        isFetching = false
    }
    
    
    func updateBadgeValue(){
        
        
    viewModel.countItemFavoriteUpdate()
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Fetch completed")
                    case .failure(let error):
                        print("Error fetching trending objects: \(error.localizedDescription)")
                    }
                }, receiveValue: { objects in
                    // Handle the fetched objects here
                    print("Fetched objects: \(objects.count)")
                    self.updateNavigationBarWithFavoriteCount(objects.count)

                })
                .store(in: &cancellables)

    }
    
    
    
    
    private func updateNavigationBarWithFavoriteCount(_ count: Int) {
        
        let backButton = BadgeButton(type: .system)
        backButton.setImage(UIImage(systemName: "suit.heart"), for: .normal)
        backButton.tintColor = .black // Set button tint color
        backButton.addTarget(self, action: #selector(backFuncs), for: .touchUpInside)
        
        if count > 0 {
            backButton.badgeValue = "\(count)"
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        
    }
        
    
    
    override func setNavigationBar(title: String?) {
        //title
        navigationItem.title = title ?? ""
        navigationItem.titleView?.tintColor = .white
        
        updateBadgeValue()
        
        showSearchBarButton(shouldShow: true)

    }
    
    @objc  func backFuncs() {
        self.viewModel.homePageCoordinator?.toFavoriteScreen()

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




extension HomePage : UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{
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
            self.updateBadgeValue()
            })

                
            }else{
                
                RealmControl.shared.addFavorite(searchResultss: item)
                let image = UIImage(systemName: "heart.fill")
                cell.btnFavorite.setImage(image, for: .normal)
                cell.isFavorite = true
                self.updateBadgeValue()
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

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let position = scrollView.contentOffset.y
        
        if position > (self.tableView.contentSize.height - 100 - scrollView.frame.size.height){

        //To update the data when it reaches the last point in tableview
        //fetchDataIfNeeded()
 
        }
        
    }
}




