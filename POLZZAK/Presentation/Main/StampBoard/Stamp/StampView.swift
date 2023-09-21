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
    weak var stampViewDelegate: StampViewDelegate?
    
    init(frame: CGRect = .zero, size: StampSize) {
        self.size = size
        let layout = StampView.getLayout(stampViewSize: size)
        super.init(frame: frame, collectionViewLayout: layout)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        register(StampCell.self, forCellWithReuseIdentifier: StampCell.reuseIdentifier)
        register(StampFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: StampFooterView.reuseIdentifier)
        dataSource = self
        delegate = self
    }
    
    private func configureLayout() {
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray200.cgColor
    }
}

// MARK: - DataSource

extension StampView: UICollectionViewDataSource {
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

// MARK: - Delegate

extension StampView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        stampViewDelegate?.stampView(self, didSelectItemAt: indexPath)
    }
}

// MARK: - Layout

extension StampView {
    static func getLayout(stampViewSize: StampSize, sectionInset: CGFloat = 20) -> UICollectionViewLayout {
        let numberOfItemPerLine = stampViewSize.numberOfItemsPerLine
        let itemFractionalWidthFraction = 1.0 / CGFloat(numberOfItemPerLine)
        
        let screenWidth = UIApplication.shared.width
        let spacing: CGFloat = screenWidth/(5.86*CGFloat(numberOfItemPerLine))
        let itemSpacing = spacing == 0 ? 16 : spacing
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(itemFractionalWidthFraction),
            heightDimension: .fractionalWidth(itemFractionalWidthFraction)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        // Group
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(.greatestFiniteMagnitude)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: numberOfItemPerLine)
        group.interItemSpacing = .fixed(itemSpacing)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = itemSpacing
        section.contentInsets = NSDirectionalEdgeInsets(top: sectionInset, leading: sectionInset, bottom: sectionInset, trailing: sectionInset)
        
        // Footer
        if stampViewSize.isMoreStatus {
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(60.0)
            )
            let footer = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: UICollectionView.elementKindSectionFooter,
                alignment: .bottom
            )
            section.boundarySupplementaryItems = [footer]
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - StampViewHeightConstraintDelegate

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

// MARK: - StampViewDelegate

protocol StampViewDelegate: AnyObject {
    func stampView(_ stampView: StampView, didSelectItemAt indexPath: IndexPath)
}

extension StampViewDelegate {
    func stampView(_ stampView: StampView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
