//
//  StampView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit

import SnapKit

/// Never change dataSource. Changing missionListViewDataSource is OK.
class StampView: UICollectionView {
    private let size: StampSize
    private var showMore: Bool = false {
        didSet {
            reloadDataWithAnimation()
        }
    }
    
    weak var heightConstraintDelegate: StampViewHeightConstraintDelegate?
    
    init(frame: CGRect = .zero, size: StampSize) {
        self.size = size
        let layout = CollectionViewLayoutFactory.getStampViewLayout(stampViewSize: size)
        super.init(frame: frame, collectionViewLayout: layout)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StampView: UICollectionViewDataSource {
    private func configureView() {
        register(StampCell.self, forCellWithReuseIdentifier: StampCell.reuseIdentifier)
        register(StampFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: StampFooterView.reuseIdentifier)
        dataSource = self
    }
    
    private func configureLayout() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray200.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard size.isMoreStatus == false || showMore == true else { return size.reducedCount }
        return size.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampCell.reuseIdentifier, for: indexPath) as! StampCell
        cell.setNumber(number: indexPath.item+1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampFooterView.reuseIdentifier, for: indexPath) as! StampFooterView
            footer.actionWhenUserTapMoreButton = { [weak self] in
                self?.showMore.toggle()
                self?.heightConstraintDelegate?.updateStampViewHeightConstraints()
            }
            return footer
        default:
            return UICollectionReusableView()
        }
    }
}

protocol StampViewHeightConstraintDelegate: UIViewController {
    var stampView: StampView { get }
    var stampViewHeight: Constraint? { get set }
    
    func updateStampViewHeightConstraints()
}

extension StampViewHeightConstraintDelegate {
    func updateStampViewHeightConstraints() {
        view.layoutIfNeeded()
        
        let stampViewContentSizeHeight = stampView.collectionViewLayout.collectionViewContentSize.height
        
        stampViewHeight?.deactivate()

        stampView.snp.makeConstraints { make in
            stampViewHeight = make.height.equalTo(stampViewContentSizeHeight).constraint
        }
    }
}
