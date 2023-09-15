//
//  MissionAddView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/16.
//

import UIKit

final class MissionAddView: UICollectionView {
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
        register(MissonAddTextFieldCell.self, forCellWithReuseIdentifier: MissonAddTextFieldCell.reuseIdentifier)
        register(MissonAddButtonCell.self, forCellWithReuseIdentifier: MissonAddButtonCell.reuseIdentifier)
        register(MissionExampleButtonCell.self, forCellWithReuseIdentifier: MissionExampleButtonCell.reuseIdentifier)
        dataSource = self
    }
    
    private func configureLayout() {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray200.cgColor
    }
}

// MARK: - UICollectionViewDataSource

extension MissionAddView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1...2:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissonAddTextFieldCell.reuseIdentifier, for: indexPath) as? MissonAddTextFieldCell else { fatalError("Couldn't dequeue MissonAddTextFieldCell") }
            
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissonAddButtonCell.reuseIdentifier, for: indexPath) as? MissonAddButtonCell else { fatalError("Couldn't dequeue MissonAddButtonCell") }
            
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionExampleButtonCell.reuseIdentifier, for: indexPath) as? MissionExampleButtonCell else { fatalError("Couldn't dequeue MissionExampleButtonCell") }
            
            return cell
        default:
            fatalError("")
        }
        
    }
}

// MARK: - Layout

extension MissionAddView {
    static func getLayout() -> UICollectionViewLayout {
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
