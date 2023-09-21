//
//  StampSizeSelectionView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/16.
//

import UIKit

final class StampSizeSelectionView: UICollectionView {
    private let stampSizeList: [Int] = StampSize.allCases.map { $0.rawValue.count }
    
    init() {
        let layout = StampSizeSelectionView.getLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        register(StampSizeSelectionCell.self, forCellWithReuseIdentifier: StampSizeSelectionCell.reuseIdentifier)
        dataSource = self
    }
    
    private func configureLayout() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray200.cgColor
    }
}

// MARK: - UICollectionViewDataSource

extension StampSizeSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stampSizeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampSizeSelectionCell.reuseIdentifier, for: indexPath) as? StampSizeSelectionCell else { fatalError("Couldn't dequeue StampSizeSelectionCell") }
        cell.setNumber(number: stampSizeList[indexPath.item])
        return cell
    }
}

// MARK: - Layout

extension StampSizeSelectionView {
    static func getLayout() -> UICollectionViewLayout {
        let numberOfItemPerLine = 5
        let itemFractionalWidth = 1.0 / CGFloat(numberOfItemPerLine)
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemFractionalWidth),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(38.0) // FIXME: absolute말고 fractionalHeight로 바꾸기(하드코딩 줄이기)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfItemPerLine)
        group.interItemSpacing = .fixed(6)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
