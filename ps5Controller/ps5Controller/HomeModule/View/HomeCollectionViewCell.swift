import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
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

