//
//  StampView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit

/// Never change dataSource. Changing missionListViewDataSource is OK.
class StampView: UICollectionView {
    private let size: StampSize
    private var showMore: Bool = false {
        didSet {
            reloadDataWithAnimation()
        }
    }
     
    var actionWhenUserTapMoreButton: (() -> Void)?
    
    init(frame: CGRect = .zero, size: StampSize) {
        self.size = size
        let layout = CollectionViewLayoutFactory.getStampViewLayout(stampViewSize: size)
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StampView: UICollectionViewDataSource {
    private func configure() {
        register(StampCell.self, forCellWithReuseIdentifier: StampCell.reuseIdentifier)
        register(StampFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: StampFooterView.reuseIdentifier)
        dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard size.isMoreStatus == false || showMore == true else { return size.reducedCount }
        return size.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampCell.reuseIdentifier, for: indexPath) as! StampCell
        cell.backgroundColor = .gray200
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampFooterView.reuseIdentifier, for: indexPath) as! StampFooterView
            footer.actionWhenUserTapMoreButton = { [weak self] in
                self?.showMore.toggle()
                self?.actionWhenUserTapMoreButton?()
            }
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}
