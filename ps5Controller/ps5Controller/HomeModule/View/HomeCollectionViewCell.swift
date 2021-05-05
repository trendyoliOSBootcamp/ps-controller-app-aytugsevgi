import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    static func nib() -> UINib {
        UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    }
    @IBOutlet weak private var cellButton: UIButton!
    
    func configure(with homeViewModel: HomeViewModel) {
        let image = UIImage(named: homeViewModel.image)
        cellButton.setImage(image, for: .normal)
    }
}

