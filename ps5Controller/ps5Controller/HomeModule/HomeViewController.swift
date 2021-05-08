import UIKit

protocol HomeViewInterface: AnyObject {
    func configureInitialView()
    func reloadData()
    func animateCells()
    func animateAndChangeTab(index: Int)
}

final class HomeViewController: UIViewController {
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet private var tabButtons: [UIButton]!
    @IBOutlet weak private var collectionViewHeight: NSLayoutConstraint!
    var presenter: HomePresenterInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction private func tabButtonsTapped(_ sender: UIButton) {
        presenter.didSelectTab(index: tabButtons.firstIndex(of: sender))
    }
}

extension HomeViewController: HomeViewInterface {
    func configureInitialView() {
        navigationController?.isNavigationBarHidden = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(reusableCellType: HomeCollectionViewCell.self)
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    func animateCells() {
        collectionView.transform = CGAffineTransform(translationX: view.frame.width, y: 0).scaledBy(x: 0.6, y: 0.6)
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        UIView.animate(withDuration: 1) {
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1, y: 1)
        }
    }
    
    func animateAndChangeTab(index: Int) {
        UIView.animate(withDuration: 1) {
            self.tabButtons.forEach { $0.setBackgroundImage(UIImage(named: Constant.unselectedHomeTabBackgroundImage), for: .normal) }
            self.tabButtons.forEach { $0.tintColor = UIColor(named: Constant.unselectedHomeTabTintColor) }
            self.tabButtons[index].setBackgroundImage(UIImage(named: Constant.selectedHomeTabBackgroundImage), for: .normal)
            self.tabButtons[index].tintColor = UIColor(named: Constant.selectedHomeTabTintColor)
        }
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(type: HomeCollectionViewCell.self, for: indexPath)
        let viewModel = presenter.cellForItemAt(index: indexPath.row)
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let insets = presenter.insetForSections
        return UIEdgeInsets(top: CGFloat(insets.top), left: CGFloat(insets.left), bottom: CGFloat(insets.bottom), right: CGFloat(insets.right))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        CGFloat(presenter.minimumInteritemSpacingForSections)
    }
}

extension HomeViewController: UICollectionViewDelegate { }

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = presenter.calculateCellSize(width: Double(collectionView.frame.width), originY: Double(collectionView.frame.origin.y))
        collectionViewHeight.constant = CGFloat(size.height)
        return CGSize(width: size.width, height: size.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let point = presenter.paging(xPoint: Double(targetContentOffset.pointee.x), yPoint: Double(targetContentOffset.pointee.y), contentInsetLeft: Double(collectionView.contentInset.left))
        targetContentOffset.pointee = CGPoint(x: point.x, y: point.y)
    }
}
