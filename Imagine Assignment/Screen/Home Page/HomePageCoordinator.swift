
import Foundation
import UIKit


protocol HomeChildDelagates: AnyObject {
    
    func didFinish(_ coordinator: Coordinator)
}

class HomePageCoordinator:Coordinator{
    
    private(set) var childCoordinator: [Coordinator] = []
    
    private var navigationController:UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let controller = HomePage()
        let viewModel = HomePageViewModel()
        controller.viewModel = viewModel
        viewModel.homePageCoordinator = self
        navigationController.pushViewController(controller, animated: true)
    }
    
    func toItemDetailsScreen(gifId:String){
        let itemDetailCoordinator = ItemDetailCoordinator(navigationController: navigationController)
        self.childCoordinator.append(itemDetailCoordinator)
        itemDetailCoordinator.parentCoordinator = self
        itemDetailCoordinator.gifId = gifId
        itemDetailCoordinator.from = "HomePage"
        itemDetailCoordinator.start()
    }
    
    func toFavoriteScreen(){
        let favoriteCoordinator = FavoriteCoordinator(navigationController: navigationController)
        self.childCoordinator.append(favoriteCoordinator)
        favoriteCoordinator.parentCoordinator = self
        favoriteCoordinator.start()
    }
    
}


extension HomePageCoordinator:HomeChildDelagates{
    func didFinish(_ coordinator: any Coordinator) {
  
        if let index = childCoordinator.firstIndex (where: { childCoordinator in

            childCoordinator === coordinator

        }){
            
            childCoordinator.remove(at: index)
            navigationController.popViewController(animated: true)

        }
    }
    


}

