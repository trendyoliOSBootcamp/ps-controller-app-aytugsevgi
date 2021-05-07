import UIKit

protocol HomeRouterInterface {
    func presentAlert(title: String, message: String)
}

final class HomeRouter {
    var navigationController: UINavigationController?
    
    static func createModule(using navigationController: UINavigationController? = nil) -> UIViewController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.navigationController = navigationController
        return view
    }
}

extension HomeRouter: HomeRouterInterface {
    func presentAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertView.addAction(action)
        navigationController?.present(alertView, animated: true)
    }
}
