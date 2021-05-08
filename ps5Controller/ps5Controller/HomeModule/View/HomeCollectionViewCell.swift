import UIKit

final class HomeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak private var cellButton: UIButton!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    func configure(with homeViewModel: HomeViewModel) {
        let image = UIImage(named: homeViewModel.image)
        cellButton.setImage(image, for: .normal)
        titleLabel.text = homeViewModel.title
        subtitleLabel.text = homeViewModel.subtitle
    }
}

