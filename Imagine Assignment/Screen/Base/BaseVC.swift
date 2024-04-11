
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
    
    
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

    
func showAlert(title: String,
               alertColor: UIColor? = UIColor.black,
               message: String,
               actionTitle: String,
               cancelTitle: String,
               actionHandler: (() -> Void)?,
               cancelHandler: (() -> Void)? = nil
                ) {
        
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Customize title if needed
        if let titleColor = alertColor {
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: titleColor
            ]
            let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
            alert.setValue(attributedTitle, forKey: "attributedTitle")
        }
        
        // Customize message if needed
        if let messageColor = alertColor {
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: messageColor
            ]
            let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
        }
        
        let okAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            actionHandler?()
        }
        
    let  actionColor: UIColor? = UIColor.red

        // Set color for action button if provided
        if let actionColor = actionColor {
            okAction.setValue(actionColor, forKey: "titleTextColor")
        }
        
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { (action) in
            cancelHandler?()
        }
        
        // Set color for cancel button if provided
        if let cancelColor = alertColor {
            cancelAction.setValue(cancelColor, forKey: "titleTextColor")
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
}

    
    
    func showErrorAlert(message: String, titleColor: UIColor? = UIColor.black, messageColor: UIColor? = UIColor.black) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        // Customize title color if provided
        if let titleColor = titleColor {
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: titleColor
            ]
            let attributedTitle = NSAttributedString(string: "Error", attributes: titleAttributes)
            alert.setValue(attributedTitle, forKey: "attributedTitle")
        }
        
        // Customize message color if provided
        if let messageColor = messageColor {
            let messageAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: messageColor
            ]
            let attributedMessage = NSAttributedString(string: message, attributes: messageAttributes)
            alert.setValue(attributedMessage, forKey: "attributedMessage")
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true, completion: nil)
    }

    
    
    func setNavigationBar(title:String?){
        navigationItem.title = title ?? ""
        navigationItem.titleView?.tintColor = .white

    }
    
    func showSearchBarButton(shouldShow: Bool) {
        if shouldShow {
             let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(handleShowSearchBar))
             searchButton.tintColor = .black
             navigationItem.rightBarButtonItem = searchButton
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
