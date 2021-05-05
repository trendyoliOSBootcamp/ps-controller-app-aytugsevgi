import Foundation

protocol HomePresenterInterface {
    func notifyViewLoaded()
    func notifyViewDidAppear()
    func changeTab(type: HomeTabType)
    func productListFetched(productList: [Product])
    func productListFetchFailed(with errorMessage: String)
}

typealias HomeViewModel = (title: String, subtitle: String, image: String)
typealias Rect = (origin: Point, size: Size)
typealias Point = (x:Double, y:Double)
typealias Size = (width: Double, height: Double)

enum HomeTabType: Int {
    case controller = 0
    case switcher
    case mouse
}

final class HomePresenter: HomePresenterInterface {
    var view: HomeViewController?
    var interactor: HomeInteractor?
    var router: HomeRouter?
    private var homeViewModels: [HomeViewModel]?
    private var cellRatio: Double = 231 / 291
    private var cellCountOnScreen: Double = 1 + 92/231
    private var cellSize = Size(width: 0, height: 0)
    private var selectedHomeTabType = HomeTabType.controller
    func getHomeViewModels() -> [HomeViewModel]? {
        homeViewModels
    }
    
    func notifyViewLoaded() {
        view?.configureInitialView()
        interactor?.fetchProductList(type: selectedHomeTabType)
    }
    
    func notifyViewDidAppear() {
        
    }
    
    func changeTab(type: HomeTabType) {
        guard type != selectedHomeTabType else { return }
        selectedHomeTabType = type
        interactor?.fetchProductList(type: type)
    }
    
    func insetForSections() -> (left: Double, right: Double, top: Double, bottom: Double) {
        let insets = (left: 28.0, right: 28.0, top: 0.0, bottom: 0.0)
        return insets
    }
    
    func minimumInteritemSpacingForSections() -> Double {
        24
    }
    
    func calculateCellSize(width: Double, originY: Double) -> (Rect, Size) {
        let spacing = insetForSections().left + minimumInteritemSpacingForSections()
        let widthWithoutSpacing = width - spacing
        let cellWidth = widthWithoutSpacing / cellCountOnScreen
        let cellHeight = cellWidth / cellRatio
        let collectionViewSize = Size(width: width, height: cellHeight)
        let origin = (x: 50.0, y: (originY - 500.0))
        let collectionViewFrame = Rect(origin: origin, size: collectionViewSize)
        cellSize = Size(width: cellWidth, height: cellHeight)
        return (collectionViewFrame, cellSize)
    }
    
    func paging(xPoint: Double, yPoint: Double, contentInsetLeft: Double) -> Point {
        let cellWidthWithSpace: Double = cellSize.width + insetForSections().left
        let inertialTargetX = xPoint
        let offsetFromPreviousPage = (inertialTargetX + contentInsetLeft).truncatingRemainder(dividingBy: cellWidthWithSpace)
        // move nearest cell
        let pagedX: Double
        if offsetFromPreviousPage > cellWidthWithSpace / 2 {
            pagedX = inertialTargetX + (cellWidthWithSpace - offsetFromPreviousPage)
        } else {
            pagedX = inertialTargetX - offsetFromPreviousPage
        }
        let point = Point(x: pagedX, y: yPoint)
        return point
    }
    
    func productListFetched(productList: [Product]) {
        var homeViewModels = [HomeViewModel]()
        for product in productList {
            guard let title = product.name,
                  let subtitle = product.description,
                  let image = product.image else { continue }
            let homeViewModel: HomeViewModel = (title, subtitle, image)
            homeViewModels.append(homeViewModel)
        }
        self.homeViewModels = homeViewModels
        
    
        self.view?.reloadData()
     
        self.view?.animateWhenReloadData()
        
    }
    
    func productListFetchFailed(with errorMessage: String) {
        router?.presentAlert("Error", errorMessage)
    }
}
