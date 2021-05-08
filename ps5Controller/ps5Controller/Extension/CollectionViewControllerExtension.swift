import UIKit

extension UICollectionView {
    func register(reusableCellType: UICollectionViewCell.Type) {
        self.register(reusableCellType.nib, forCellWithReuseIdentifier: reusableCellType.identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(type: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: type.identifier, for: indexPath) as! T
    }
}
