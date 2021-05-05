import UIKit

protocol HomeViewInterface {
    func configureInitialView()
    func reloadData()
    func animateWhenReloadData()
}

class HomeViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
    
    var cellRatio: Double = 231 / 291
    var presenter: HomePresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.notifyViewLoaded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.notifyViewDidAppear()
    }

}

extension HomeViewController: HomeViewInterface {
    func configureInitialView() {
        navigationController?.isNavigationBarHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HomeCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func animateWhenReloadData() {
        self.collectionView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        UIView.animate(withDuration: 1) {
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let homeViewModels = presenter?.getHomeViewModels() else { return 0 }
        return homeViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell,
              let homeViewModels = presenter?.getHomeViewModels() else { return UICollectionViewCell() }
        cell.configure(with: homeViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let insets = presenter?.insetForSections() else { return UIEdgeInsets.zero }
        return UIEdgeInsets(top: CGFloat(insets.top), left: CGFloat(insets.left), bottom: CGFloat(insets.bottom), right: CGFloat(insets.right))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let spacing = presenter?.minimumInteritemSpacingForSections() else { return 0 }
        return CGFloat(spacing)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let presenter = presenter else { return CGSize(width: 0, height: 0) }
        let (frame, size) = presenter.calculateCellSize(width: Double(collectionView.frame.width), originY: Double(collectionView.frame.origin.y))
        collectionView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        return CGSize(width: size.width, height: size.height)
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let presenter = presenter else { return }
        let point = presenter.paging(xPoint: Double(targetContentOffset.pointee.x), yPoint: Double(targetContentOffset.pointee.y), contentInsetLeft: Double(collectionView.contentInset.left))
        targetContentOffset.pointee = CGPoint(x: point.x, y: point.y)
    }
}
