//
//  CollectionViewLayoutFactory.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

import UIKit

class CollectionViewLayoutFactory {
    static func getStampViewLayout(stampViewSize: StampSize, sectionInset: CGFloat = 20) -> UICollectionViewLayout {
        let numberOfItemPerLine = stampViewSize.numberOfItemsPerLine
        let itemFractionalWidthFraction = 1.0 / CGFloat(numberOfItemPerLine)
        
        let screenWidth = UIApplication.shared.width ?? 0
        let inset: CGFloat = screenWidth/25 // TODO: 기획에 따라 바뀌어야 함 (2023.05.23)
        let itemSpacing = inset == 0 ? 16 : inset
        
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
                heightDimension: .absolute(50.0) // TODO: 피그마에는 60인데 iOS에서는 너무 커보여서 50으로 했음. 수정 필요 (2023.05.23)
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
