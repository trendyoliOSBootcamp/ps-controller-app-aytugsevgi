import UIKit

extension UICollectionViewCell {
    static var identifier: String { .init(describing: self) }
    static var nib: UINib { UINib(nibName: .init(describing: self), bundle: nil) }
}
