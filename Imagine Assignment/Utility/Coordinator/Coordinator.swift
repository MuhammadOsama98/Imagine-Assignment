
import Foundation


protocol Coordinator:AnyObject{
    var childCoordinator:[Coordinator]{get}
    func start()
}
