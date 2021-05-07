import UIKit
protocol ReusableView: AnyObject {
    static var identifier: String { get }
    static var nib: UINib { get }
}

extension ReusableView where Self: UIView {
    static var identifier: String { .init(describing: self) }
    static var nib: UINib { UINib(nibName: .init(describing: self), bundle: nil) }
}

extension UICollectionViewCell: ReusableView { }
