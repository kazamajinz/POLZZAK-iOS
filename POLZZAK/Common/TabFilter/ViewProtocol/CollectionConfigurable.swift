//
//  CollectionConfigurableㅖ.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/27.
//

import UIKit

protocol CollectionLayoutConfigurable: UICollectionViewDelegateFlowLayout {
    func configureHeaderAndFooter(for section: NSCollectionLayoutSection, isDataNotEmpty: Bool, filterType: FilterType)
}

extension CollectionLayoutConfigurable {
    func configureHeaderAndFooter(for section: NSCollectionLayoutSection, isDataNotEmpty: Bool, filterType: FilterType) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        setupBoundaryItems(for: section, with: sectionHeader, isDataNotEmpty: isDataNotEmpty, filterType: filterType)
        adjustContentInsetsAndScrolling(for: section, filterType: filterType)
    }
    
    private func setupBoundaryItems(for section: NSCollectionLayoutSection, with header: NSCollectionLayoutBoundarySupplementaryItem, isDataNotEmpty: Bool, filterType: FilterType) {
        if isDataNotEmpty && filterType == .all {
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            section.boundarySupplementaryItems = [header, sectionFooter]
        } else if filterType == .all {
            section.boundarySupplementaryItems = [header]
        }
    }
    
    private func adjustContentInsetsAndScrolling(for section: NSCollectionLayoutSection, filterType: FilterType) {
        filterType != .all
        ? (section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 26))
        : (section.orthogonalScrollingBehavior = .groupPaging)
    }
}
