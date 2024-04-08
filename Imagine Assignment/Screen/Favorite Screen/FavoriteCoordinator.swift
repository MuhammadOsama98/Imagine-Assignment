

import Foundation
import UIKit


protocol FavoriteTranstionDelegate: AnyObject {
    func backHome()
}

protocol FavoriteChildDelagates: AnyObject {
    
    func didFinish(_ coordinator: Coordinator)
}

class FavoriteCoordinator:Coordinator{
    
    
    private(set) var childCoordinator: [any Coordinator] = []
    
    private var navigationController:UINavigationController

    weak var parentCoordinator: HomeChildDelagates?

    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }

    
    func start() {
        
        let controller = FavoriteScreen()
        let viewModel = FavoriteViewModel()
        controller.viewModel = viewModel
        viewModel.favoriteCoordinator = self
        navigationController.pushViewController(controller, animated: true)

    }
    
    
    func goToViewFavorite(gifId:String){
            let itemDetailCoordinator = ItemDetailCoordinator(navigationController: navigationController)
            self.childCoordinator.append(itemDetailCoordinator)
            itemDetailCoordinator.gifId = gifId
            itemDetailCoordinator.from = "FavoriteItem"
            itemDetailCoordinator.favoriteCoordinator = self
            itemDetailCoordinator.start()
        
    }
    
    
}

extension FavoriteCoordinator:FavoriteTranstionDelegate{
    func backHome() {
        parentCoordinator?.didFinish(self)
    }
    
    
}

extension FavoriteCoordinator:FavoriteChildDelagates{
    func didFinish(_ coordinator: any Coordinator) {
  
        if let index = childCoordinator.firstIndex (where: { childCoordinator in

            childCoordinator === coordinator

        }){
            
            childCoordinator.remove(at: index)
            navigationController.popViewController(animated: true)

        }
    }
    
    
}
