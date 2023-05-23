//
//  MissionListView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/18.
//

import UIKit

protocol MissionListViewable {
    var missionNumber: Int { get }
    var missionTitle: String { get }
}

protocol MissionListViewDataSource {
    func missionListViewNumberOfItems() -> Int
    func missionListView(dataForItemAt indexPath: IndexPath) -> MissionListViewable
}

/// Never change dataSource. Changing missionListViewDataSource is OK.
class MissionListView: UICollectionView {
    private let inset: CGFloat
    private var showMore: Bool = false {
        didSet {
            reloadDataWithAnimation()
        }
    }
    
    var actionWhenUserTapMoreButton: (() -> Void)?
    
    var missionListViewDataSource: MissionListViewDataSource?

    init(frame: CGRect = .zero, inset: CGFloat = 0) {
        self.inset = inset
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.headerTopPadding = 0
        config.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissionListView: UICollectionViewDataSource {
    private func configure() {
        register(MissionCell.self, forCellWithReuseIdentifier: MissionCell.reuseIdentifier)
        register(MissionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MissionHeaderView.reuseIdentifier)
        dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let numberOfItems = missionListViewDataSource?.missionListViewNumberOfItems() ?? 0
        guard showMore == true || numberOfItems <= 3 else { return 3 }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCell.reuseIdentifier, for: indexPath) as! MissionCell
        let data = missionListViewDataSource?.missionListView(dataForItemAt: indexPath)
        cell.titleLabel.text = data?.missionTitle
        cell.updateInset(inset: inset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MissionHeaderView.reuseIdentifier, for: indexPath) as! MissionHeaderView
            header.updateInset(inset: inset)
            header.actionWhenUserTapMoreButton = { [weak self] in
                self?.showMore.toggle()
                self?.actionWhenUserTapMoreButton?()
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
