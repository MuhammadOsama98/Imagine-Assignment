
import Foundation

import UIKit


class AppCoordinator:Coordinator{
    
    
   private(set) var childCoordinator: [Coordinator] = []
   private let navigationController = UINavigationController()
   private var window: UIWindow?
    
    init(window: UIWindow? = nil) {
        self.window = window
    }

    func start() {
        let homeCoordinator = HomePageCoordinator(navigationController: navigationController)
        childCoordinator.append(homeCoordinator)
        homeCoordinator.start()
        
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
}
