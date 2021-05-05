import UIKit

protocol HomeRouterInterface {
    func presentAlert(_ title: String, _ errorMessage: String)
}

final class HomeRouter {
    var presenter: HomePresenter?
    var navigationController: UINavigationController?
    
    static func createModule(using navigationController: UINavigationController? = nil) -> UIViewController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        view.presenter = presenter
        interactor.presenter = presenter
        router.presenter = presenter
        router.navigationController = navigationController
        return view
    }
}

extension HomeRouter: HomeRouterInterface {

    func presentAlert(_ title: String, _ errorMessage: String) {
        let alertView = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertView.addAction(action)
        navigationController?.present(alertView, animated: true)
    }
}
