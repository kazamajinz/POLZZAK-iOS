//
//  ParentTypeSelectView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/02.
//

import UIKit
import Combine

final class ParentTypeSelectView: UICollectionView {
    private let types: [String]
    @Published var currentType: String?
    
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
        decelerationRate = .fast
    }
    
    func configureCurrentType(isInitial: Bool = false) {
        guard let layout = collectionViewLayout as? CarouselLayout else { return }
        
        if isInitial {
            layout.invalidateLayout()
            layoutIfNeeded()
        }
        
        guard let centerIndexPath = layout.centerIndexPath else { return }
        
        // TODO: 아래 조건문 바꿔야할듯
        let currentType = types[centerIndexPath.item] != "선택해주세요" ? types[centerIndexPath.item] : nil
        self.currentType = currentType
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        processCellUI()
        configureCurrentType()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
    }
    
    private func processCellUI() {
        guard let centerIndexPath = (collectionViewLayout as? CarouselLayout)?.centerIndexPath,
              let cell = cellForItem(at: centerIndexPath) as? ParentTypeSelectCell
        else { return }
        
        visibleCells
            .compactMap { $0 as? ParentTypeSelectCell }
            .forEach {
                $0.unEmphasizeCell()
            }
        
        cell.emphasizeCell()
    }
}

// MARK: - Layout

extension ParentTypeSelectView: UICollectionViewDelegateFlowLayout {
    enum Constants {
        static let sideItemCount = 2
    }
    
    static func getLayout() -> UICollectionViewLayout {
        let layout = CarouselLayout(scrollDirection: .vertical)
        layout.itemSize = CGSize(width: 294, height: 52)
        layout.spacing = -10
        layout.sideItemScale = 0.7
        layout.sideItemAlpha = 1
        layout.sideItemCount = Constants.sideItemCount
        return layout
    }
}
