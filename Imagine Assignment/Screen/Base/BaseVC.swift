//
//  BaseVC.swift
//  Imagine Assignment
//
//  Created by Pillars Fintech on 05/04/2024.
//

import UIKit

class BaseVC: UIViewController {
    
    
     lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = ""
        return searchBar
    }()
    
    lazy var indicator : UIActivityIndicatorView = {
            let view = UIActivityIndicatorView()
            view.style = .large
            view.hidesWhenStopped = true
            view.translatesAutoresizingMaskIntoConstraints = false

        
            return view
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        view.addSubview(indicator)

        // Set constraints to center the activity indicator
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        // Do any additional setup after loading the view.
    }
    

    func setNavigationBar(title:String?){
        navigationItem.title = title ?? ""
        navigationItem.titleView?.tintColor = .white

    }
    
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Cannot open URL")
        }
        
        
    }
    
    
    
    @objc func backFuncs() {
        
    }
    
   
    func showAlert(title: String,
                   message: String,
                   actionTitle: String,
                   cancelTitle: String,
                   actionHandler:(()->Void)?,
                   cancelHandler:(()->Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showErrorAlert(message: String) {
          let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default))
          present(alert, animated: true, completion: nil)
      }
    
    
    func showSearchBarButton(shouldShow: Bool) {
        let searchButton  = UIButton(type: .system)
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        searchButton.tintColor = .black
        searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        searchButton.addTarget(self, action:#selector(handleShowSearchBar), for: .touchUpInside)

        
        
        if shouldShow {
            navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        } else {
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func handleShowSearchBar() {
        self.searchBar.becomeFirstResponder()

            
            self.search(shouldShow: true)
    }
    
    
    func search(shouldShow: Bool) {
        showSearchBarButton(shouldShow: !shouldShow)
        searchBar.showsCancelButton = shouldShow
        searchBar.tintColor = .black
        navigationItem.titleView = shouldShow ? searchBar : nil
        
    }


}
