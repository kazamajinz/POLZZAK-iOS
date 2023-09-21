//
//  ParentTypeSelectView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/02.
//

import UIKit
import Combine

final class ParentTypeSelectView: UICollectionView {
    private let types: [MemberTypeDetail]
    @Published var currentType: MemberTypeDetail?
    private var isInitialLoading = true
    
    init(frame: CGRect = .zero, types: [MemberTypeDetail]) {
        self.types = types
        let layout = ParentTypeSelectView.getLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isInitialLoading {
            setUICenter()
            isInitialLoading = false
        }
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
    
    private func setUICenter() {
        // TODO: types.count == 0 인 경우 처리하기?
        guard let layout = collectionViewLayout as? CarouselLayout,
              let index = types.firstIndex(where: { $0.detail == "선택해주세요" }) // TODO: 하드코딩 줄이기
        else { return }
        
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                self.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredVertically, animated: false)
                layout.invalidateLayout()
                self.layoutIfNeeded()
                self.configureCurrentType()
            }
        }
    }
}

// MARK: - DataSource

extension ParentTypeSelectView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return types.count // TODO: types가 5 이하면 처리
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ParentTypeSelectCell.reuseIdentifier, for: indexPath) as? ParentTypeSelectCell else {
            fatalError("Couldn't dequeue cell as ParentTypeSelectCell")
        }
        cell.configure(title: types[indexPath.item].detail)
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
    
    private func configureCurrentType() {
        guard let layout = collectionViewLayout as? CarouselLayout,
              let centerIndexPath = layout.centerIndexPath
        else { return }
        
        currentType = types[centerIndexPath.item]
    }
}

// MARK: - Layout

extension ParentTypeSelectView {
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
