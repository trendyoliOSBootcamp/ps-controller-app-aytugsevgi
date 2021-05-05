import UIKit

protocol HomeInteractorInterface {
    func fetchControllerList()
}

final class HomeInteractor: HomeInteractorInterface {
    var presenter: HomePresenter?
    var service = Service()
    
    func fetchControllerList() {
        service.fetchProductList { [weak self] (result) in
            switch result {
            case .success(let products):
                self?.presenter?.controllerListFetched(productList: products)
            case .failure(let error):
                self?.presenter?.controllerListFetchFailed(with: error.localizedDescription)
            }
        }
    }
    
}
