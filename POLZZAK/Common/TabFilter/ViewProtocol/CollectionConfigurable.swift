//
//  CollectionConfigurable.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/27.
//

import UIKit

protocol CollectionLayoutConfigurable {
    var collectionView: UICollectionView! { get }
    func configureHeaderAndFooter(for section: NSCollectionLayoutSection, isDataNotEmpty: Bool, filterType: FilterType)
    func updateFooterViewBasedOnVisibleItems(_ visibleItems: [NSCollectionLayoutVisibleItem], with groupSizeWidth: CGFloat, at point: CGPoint)
    func handleVisibleItems(for section: NSCollectionLayoutSection, with groupSizeWidth: CGFloat)
    func createLayout(spacing: CGFloat) -> UICollectionViewLayout
    func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection
}


extension CollectionLayoutConfigurable {
    func createLayout(spacing: CGFloat) -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = spacing
        
        let layoutProvider: UICollectionViewCompositionalLayoutSectionProvider = { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return self.createSection(for: sectionIndex)
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: layoutProvider, configuration: config)
    }
    
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

extension CollectionLayoutConfigurable where Self: UIViewController {
    func updateFooterViewBasedOnVisibleItems(_ visibleItems: [NSCollectionLayoutVisibleItem], with groupSizeWidth: CGFloat, at point: CGPoint) {
        guard let sectionIndex = visibleItems.last?.indexPath.section, point.x >= 0,
              let footerView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: sectionIndex)) as? FooterViewUpdatable else {
            return
        }
        
        let cellSizeWidth = groupSizeWidth + 15
        if CGFloat(point.x).truncatingRemainder(dividingBy: CGFloat(cellSizeWidth)) == 0.0 {
            let currentCount = Int(CGFloat(point.x) / CGFloat(cellSizeWidth)) + 1
            footerView.updateCurrentCount(with: currentCount)
        }
    }
    
    func handleVisibleItems(for section: NSCollectionLayoutSection, with groupSizeWidth: CGFloat) {
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, _ in
            self?.updateFooterViewBasedOnVisibleItems(visibleItems, with: groupSizeWidth, at: point)
        }
    }
}
