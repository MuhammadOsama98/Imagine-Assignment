
import Foundation
import UIKit

protocol ItemDetailTranstionDelegate: AnyObject {
    func backToHome()
    func backFavoriteItem()
}

class ItemDetailCoordinator:Coordinator{
    private(set) var childCoordinator: [any Coordinator] = []
    
    var gifId:String?
    var from:String?
    
    weak var parentCoordinator: HomeChildDelagates?
    weak var favoriteCoordinator:FavoriteChildDelagates?

    private var navigationController:UINavigationController
    
    init(navigationController:UINavigationController) {
        self.navigationController = navigationController
    }

    
    func start() {
        let controller = ItemDetailsScreen()
        let viewModel = ItemDetailViewModel()
        controller.viewModel = viewModel
        viewModel.itemDetailCoordinator = self
        viewModel.gifId = gifId
        navigationController.fadeTo(controller)

    }
    
    
    
}


extension ItemDetailCoordinator:ItemDetailTranstionDelegate{
    func backToHome() {
        parentCoordinator?.didFinish(self)

    }
    
    func backFavoriteItem() {
        favoriteCoordinator?.didFinish(self)

    }
    
    
}
