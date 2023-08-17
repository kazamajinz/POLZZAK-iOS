//
//  ParentTypeSelectView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/02.
//

import UIKit

final class ParentTypeSelectView: UICollectionView {
    private let types: [String]
    private var previousIndex: Int = 0
    
    init(frame: CGRect = .zero, types: [String]) {
        self.types = types
        let layout = ParentTypeSelectView.getLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        dataSource = self
        delegate = self
        register(ParentTypeSelectCell.self, forCellWithReuseIdentifier: ParentTypeSelectCell.reuseIdentifier)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        isPagingEnabled = false
        contentInset = Constants.collectionViewContentInset
        decelerationRate = .fast
//        contentInsetAdjustmentBehavior = .never
    }
}

// MARK: - DataSource

extension ParentTypeSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count // TODO: types가 5 이하면 처리
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParentTypeSelectCell.reuseIdentifier, for: indexPath) as? ParentTypeSelectCell else {
            fatalError("Cannot dequeue cell as ParentTypeSelectCell")
        }
        cell.configure(title: types[indexPath.item])
        return cell
    }
}

// MARK: - Delegate

extension ParentTypeSelectView: UICollectionViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let scrolledOffsetX = targetContentOffset.pointee.x + scrollView.contentInset.left
        let cellWidth = Constants.itemSize.width + Constants.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        targetContentOffset.pointee = CGPoint(x: index * cellWidth - scrollView.contentInset.left, y: scrollView.contentInset.top)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrolledOffsetX = scrollView.contentOffset.x + scrollView.contentInset.left
        let cellWidth = Constants.itemSize.width + Constants.itemSpacing
        let index = round(scrolledOffsetX / cellWidth)
        let indexPath = IndexPath(item: Int(index), section: 0)
        
        if let cell = cellForItem(at: indexPath) {
            animateZooming(cell: cell, zoom: true)
        }
        
        if Int(index) != previousIndex {
            let previousIndexPath = IndexPath(item: previousIndex, section: 0)
            if let previousCell = cellForItem(at: previousIndexPath) {
                animateZooming(cell: previousCell, zoom: false)
            }
            previousIndex = Int(index)
        }
    }
    
    private func animateZooming(cell: UICollectionViewCell, zoom: Bool) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                if zoom {
                    cell.transform = .identity
                } else {
                    cell.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            },
            completion: nil
        )
    }
}

// MARK: - Layout

extension ParentTypeSelectView: UICollectionViewDelegateFlowLayout {
    enum Constants {
        static let itemSize = CGSize(width: 200, height: 500)
        static let itemSpacing = 20.0
        
        static var insetX: CGFloat {
            return (UIApplication.shared.width - itemSize.width) / 2.0
        }
        static var collectionViewContentInset: UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        }
    }
    
    static func getLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = Constants.itemSize
        layout.minimumLineSpacing = Constants.itemSpacing
        layout.minimumInteritemSpacing = 0
        return layout
    }
}
