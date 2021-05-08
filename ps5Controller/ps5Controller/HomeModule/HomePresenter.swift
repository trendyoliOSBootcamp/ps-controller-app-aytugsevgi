import Foundation

protocol HomePresenterInterface {
    var insetForSections: Inset { get }
    var numberOfItemsInSection: Int { get }
    var minimumInteritemSpacingForSections: Double { get }
    
    func viewDidLoad()
    func didSelectTab(index: Int?)
    func calculateCellSize(width: Double, originY: Double) -> Size
    func cellForItemAt(index: Int) -> HomeViewModel
    func paging(xPoint: Double, yPoint: Double, contentInsetLeft: Double) -> Point
}

protocol HomePresenterOutputInterface: AnyObject {
    func productListFetched(productList: [Product])
    func productListFetchFailed(with errorMessage: String)
}

typealias Rect = (origin: Point, size: Size)
typealias Point = (x:Double, y:Double)
typealias Size = (width: Double, height: Double)
typealias Inset = (left: Double, right: Double, top: Double, bottom: Double)

final class HomePresenter: HomePresenterInterface {
    private weak var view: HomeViewInterface?
    private let interactor: HomeInteractorInterface
    private let router: HomeRouterInterface
    private var homeViewModels: [HomeViewModel]?
    private var cellSize = Size(width: 0, height: 0)
    private var selectedHomeTabType = HomeTabType.controller
    var insetForSections: Inset { Inset(left: 28.0, right: 28.0, top: 0.0, bottom: 0.0) }
    var numberOfItemsInSection: Int { homeViewModels?.count ?? 0 }
    let minimumInteritemSpacingForSections: Double = 24
    
    init(view: HomeViewController, interactor: HomeInteractorInterface, router: HomeRouterInterface) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        view?.configureInitialView()
        interactor.fetchProductList(type: selectedHomeTabType)
    }
    
    func didSelectTab(index: Int?) {
        guard let index = index,
              let type = HomeTabType(rawValue: index),
              type != selectedHomeTabType else { return }
        selectedHomeTabType = type
        view?.animateAndChangeTab(index: index)
        interactor.fetchProductList(type: type)
    }
    
    func calculateCellSize(width: Double, originY: Double) -> Size {
        let spacing = insetForSections.left + minimumInteritemSpacingForSections
        let widthWithoutSpacing = width - spacing
        let cellWidth = widthWithoutSpacing / Constant.homeCellCountOnScreen
        let cellHeight = cellWidth / Constant.homeCellRatio
        cellSize = Size(width: cellWidth, height: cellHeight)
        return cellSize
    }
    
    func cellForItemAt(index: Int) -> HomeViewModel {
        return homeViewModels![index]
    }
    
    func paging(xPoint: Double, yPoint: Double, contentInsetLeft: Double) -> Point {
        let cellWidthWithSpace: Double = cellSize.width + insetForSections.left
        let inertialTargetX = xPoint
        let offsetFromPreviousPage = (inertialTargetX + contentInsetLeft).truncatingRemainder(dividingBy: cellWidthWithSpace)
        let pagedX: Double
        if offsetFromPreviousPage > cellWidthWithSpace / 2 {
            pagedX = inertialTargetX + (cellWidthWithSpace - offsetFromPreviousPage)
        } else {
            pagedX = inertialTargetX - offsetFromPreviousPage
        }
        let point = Point(x: pagedX, y: yPoint)
        return point
    }
}

extension HomePresenter: HomePresenterOutputInterface {
    func productListFetched(productList: [Product]) {
        let homeViewModels: [HomeViewModel] = productList.compactMap { HomeViewModel(title: $0.name, subtitle: $0.description, image: $0.image) }
        self.homeViewModels = homeViewModels
        view?.reloadData()
        view?.animateCells()
    }
    
    func productListFetchFailed(with errorMessage: String) {
        router.presentAlert(title: "Error", message: errorMessage)
    }
}
