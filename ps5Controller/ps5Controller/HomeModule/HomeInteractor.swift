import UIKit

protocol HomeInteractorInterface {
    func fetchProductList(type: HomeTabType)
}

final class HomeInteractor: HomeInteractorInterface {
    var presenter: HomePresenter?
    private let service = Service()
    
    func fetchProductList(type: HomeTabType) {
        service.fetchProductList(type: type) { [weak self] (result) in
            switch result {
            case .success(let products):
                self?.presenter?.productListFetched(productList: products)
            case .failure(let error):
                self?.presenter?.productListFetchFailed(with: error.localizedDescription)
            }
        }
    }
}
