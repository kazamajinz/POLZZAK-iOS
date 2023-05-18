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

class MissionListView: UICollectionView {
    private let inset: CGFloat
    
    var missionListViewDataSource: MissionListViewDataSource?

    init(frame: CGRect = .zero, inset: CGFloat) {
        self.inset = inset
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.headerTopPadding = 0
        config.showsSeparators = false
        config.backgroundColor = .blue200
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
        return missionListViewDataSource?.missionListViewNumberOfItems() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCell.reuseIdentifier, for: indexPath) as! MissionCell
        let data = missionListViewDataSource?.missionListView(dataForItemAt: indexPath)
        cell.titleLabel.text = data?.missionTitle ?? "미션 제목이 들어가는 자리입니다."
        cell.updateInset(inset: inset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MissionHeaderView.reuseIdentifier, for: indexPath) as! MissionHeaderView
            header.updateInset(inset: inset)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}
