//
//  CollectionViewLayoutFactory.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

import UIKit

class CollectionViewLayoutFactory {
    static func getStampViewLayout(stampViewSize: StampSize, itemInset: CGFloat = 16, sectionInset: CGFloat = 20) -> UICollectionViewLayout {
        let numberOfItemPerLine = stampViewSize.numberOfItemsPerLine
        let itemFractionalWidthFraction = 1.0 / CGFloat(numberOfItemPerLine)
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
            heightDimension: .fractionalWidth(itemFractionalWidthFraction)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(.greatestFiniteMagnitude)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfItemPerLine)
        group.interItemSpacing = .fixed(itemInset)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemInset
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        
        // Footer
        if stampViewSize.isMoreStatus {
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50.0)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            section.boundarySupplementaryItems = [footer]
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
