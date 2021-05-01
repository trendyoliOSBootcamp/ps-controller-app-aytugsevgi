//
//  ViewController.swift
//  ps5Controller
//
//  Created by aytug on 1.05.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var cellSize: CGSize = CGSize(width: 0, height: 0)
    var products: [Product] = [.init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseBlack")),
                               .init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseWhite")),
                               .init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseBlack")),
                               .init(name: "Dual Sense", description: "Official PS5 controller", image: UIImage(named: "dualSenseBlack"))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateCollectionView()
    }

    func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ControllerCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: ControllerCollectionViewCell.identifier)
    }
    
    func animateCollectionView() {
        self.collectionView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        UIView.animate(withDuration: 1) {
            self.collectionView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
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
        let collectionViewSize = CGSize(width: collectionView.frame.width, height: cellHeight)
        let origin = CGPoint(x: 50, y: collectionView.frame.origin.y - 500.0)
        self.collectionView.frame = CGRect(origin: origin, size: collectionViewSize)
        self.cellSize = CGSize(width: cellWidth, height: cellHeight)
        return self.cellSize
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthWithSpace: CGFloat = cellSize.width + layout.sectionInset.left
   
        let inertialTargetX = targetContentOffset.pointee.x
        let offsetFromPreviousPage = (inertialTargetX + collectionView.contentInset.left).truncatingRemainder(dividingBy: cellWidthWithSpace)
        
        // move nearest cell
        let pagedX: CGFloat
        if offsetFromPreviousPage > cellWidthWithSpace / 2 {
            pagedX = inertialTargetX + (cellWidthWithSpace - offsetFromPreviousPage)
        } else {
            pagedX = inertialTargetX - offsetFromPreviousPage
        }
        
        let point = CGPoint(x: pagedX, y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
    
    }
}
