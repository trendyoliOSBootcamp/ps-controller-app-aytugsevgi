import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    static func nib() -> UINib {
        UINib(nibName: "HomeCollectionViewCell", bundle: nil)
    }
    @IBOutlet weak private var cellButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func configure(with homeViewModel: HomeViewModel) {
        let image = UIImage(named: homeViewModel.image)
        cellButton.setImage(image, for: .normal)
        titleLabel.text = homeViewModel.title
        subtitleLabel.text = homeViewModel.subtitle
    }
}

