//
//  ViewController.swift
//  ps5Controller
//
//  Created by aytug on 1.05.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var products: [Product] = [.init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseBlack")),
                               .init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseWhite")),
                               .init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseBlack")),
                               .init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseBlack"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ControllerCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: ControllerCollectionViewCell.identifier)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ControllerCollectionViewCell.identifier, for: indexPath)
                as? ControllerCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: products[indexPath.row])
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ratio: CGFloat = 231 / 291
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize(width: 0, height: 0) }
        let spacing = layout.sectionInset.left + layout.minimumInteritemSpacing
        let itemCountOnScreen: CGFloat = 1 + 92/231
        let widthWithoutSpacing = collectionView.frame.width - spacing
        let cellWidth = widthWithoutSpacing / itemCountOnScreen
        let cellHeight = cellWidth / ratio
        print("DEBUG: Cell Width is: \(cellWidth)")
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidth: CGFloat = 276 // need to get awake collectionView cell width
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = cellWidth + layout.minimumLineSpacing
        let offset = targetContentOffset.pointee
        let index = (offset.x) / (cellWidthIncludingSpacing)
        let roundedIndex = round(index)
        guard let _ = collectionView.cellForItem(at: .init(row: Int(roundedIndex), section: 0)) else { return }
        let indexPath = IndexPath(row: Int(roundedIndex), section: 0)
        self.collectionView.layoutIfNeeded()
        self.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)

        }
    
}
