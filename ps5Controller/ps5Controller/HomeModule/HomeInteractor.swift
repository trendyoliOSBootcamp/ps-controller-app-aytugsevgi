protocol HomeInteractorInterface {
    func fetchProductList(type: HomeTabType)
}

final class HomeInteractor: HomeInteractorInterface {
    var output: HomePresenterOutputInterface?
    private let service = Service()
    
    func fetchProductList(type: HomeTabType) {
        service.fetchProductList(type: type) { [weak output] (result) in
            switch result {
            case .success(let products):
                output?.productListFetched(productList: products)
            case .failure(let error):
                output?.productListFetchFailed(with: error.localizedDescription)
            }
        }
    }
}
