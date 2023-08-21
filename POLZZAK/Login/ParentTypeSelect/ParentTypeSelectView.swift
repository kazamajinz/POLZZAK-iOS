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
//        contentInset = Constants.collectionViewContentInset
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
    
}

// MARK: - Layout

extension ParentTypeSelectView: UICollectionViewDelegateFlowLayout {
    static func getLayout() -> UICollectionViewLayout {
        let layout = CarouselLayout(scrollDirection: .vertical)
        layout.itemSize = CGSize(width: 294, height: 52)
        layout.spacing = -10
        layout.sideItemScale = 0.7
        layout.sideItemAlpha = 1
        return layout
    }
}
