//
//  FavoriteScreen.swift
//  Imagine Assignment
//
//  Created by Pillars Fintech on 06/04/2024.
//

import UIKit

class FavoriteScreen: BaseVC {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    

    var viewModel  = FavoriteViewModel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTrending()
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()


    }
    
    
    private func setupNavigationBar() {
         self.navigationItem.setHidesBackButton(true, animated: true)
         self.setNavigationBar(title: "Favorite Item")
     }
    
    
    override func setNavigationBar(title: String?) {
        navigationItem.title = title ?? ""
        navigationItem.titleView?.tintColor = .white
        
      let backButton  = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.backward"), for: .normal)
        backButton.tintColor = .black
        backButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        backButton.addTarget(self, action:#selector(backFuncs), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton) 

    }
    
    @objc override func backFuncs() {
        viewModel.goToBack()
        
    }




}



extension FavoriteScreen:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    private func setupCollectionView() {
         collectionView.register(FavoriteCell.self, forCellWithReuseIdentifier: FavoriteCell.reuseID)
         collectionView.delegate = self
         collectionView.dataSource = self
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
               flowLayout.estimatedItemSize = CGSize(width: 1, height: 1) // Set a non-zero size for estimation
           }
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteCell.reuseID, for: indexPath) as! FavoriteCell
        
        let searchResult = viewModel.searchResults[indexPath.row]
             cell.setData(searchResult: searchResult)
             cell.setupUI()
        
        cell.buttonAction = { [weak self] in
            guard let self = self else { return }
            
                self.showAlert(title: "Delete", message: "Are you sure you want to delete this item?", actionTitle: "Delete", cancelTitle: "Cancel", actionHandler: {
                    RealmControl.shared.deleteFavorite(id: searchResult.id)
                    self.viewModel.fetchTrending()
                    self.collectionView.reloadData()
                })
        }
        return cell
        
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let searchResult = viewModel.searchResults[indexPath.row]
        viewModel.favoriteCoordinator?.goToViewFavorite(gifId: searchResult.id)
    }

    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 100 , height: 100)

    }


    

}


