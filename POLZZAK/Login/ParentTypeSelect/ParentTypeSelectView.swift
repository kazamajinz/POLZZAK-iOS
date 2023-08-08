//
//  ParentTypeSelectView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/02.
//

import UIKit

final class ParentTypeSelectView: UICollectionView {
    private let types: [String]
    
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
    }
}

// MARK: - DataSource

extension ParentTypeSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5 // TODO: types가 5 이하면 처리
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParentTypeSelectCell.reuseIdentifier, for: indexPath) as? ParentTypeSelectCell else {
            fatalError("Cannot dequeue cell as ParentTypeSelectCell")
        }
        cell.configure(title: "보호자")
        return cell
    }
}

// MARK: - Delegate

extension ParentTypeSelectView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.8) {
            cell.alpha = 1
        }
    }
}

// MARK: - Layout

extension ParentTypeSelectView {
    static func getLayout() -> UICollectionViewLayout {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(294.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(52.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0 // -20.0
//        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
