//
//  CollectionViewLayoutFactory.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

import UIKit

class CollectionViewLayoutFactory {
    static func getMissionListViewLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.headerTopPadding = 0
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    static func getStampViewLayout(stampViewSize: StampSize, sectionInset: CGFloat = 20) -> UICollectionViewLayout {
        let numberOfItemPerLine = stampViewSize.numberOfItemsPerLine
        let itemFractionalWidthFraction = 1.0 / CGFloat(numberOfItemPerLine)
        
        let screenWidth = UIApplication.shared.width
        let spacing: CGFloat = screenWidth/(5.86*CGFloat(numberOfItemPerLine))
        let itemSpacing = spacing == 0 ? 16 : spacing
        
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
        group.interItemSpacing = .fixed(itemSpacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        
        // Footer
        if stampViewSize.isMoreStatus {
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60.0)
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
