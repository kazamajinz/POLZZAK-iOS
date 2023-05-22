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
    private let showMoreStamp: ShowMoreStamp
    private var showMoreStatus: Bool = false {
        didSet {
            reloadDataWithAnimation()
        }
    }

    init(frame: CGRect = .zero, size: StampSize) {
        self.size = size
        self.showMoreStamp = size.showMoreStamp
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
        dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let numberOfItems = stampViewDataSource?.stampViewNumberOfItems() ?? 0
//        guard showMore == true || numberOfItems <= 3 else { return 3 }
//        return numberOfItems
        return size.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampCell.reuseIdentifier, for: indexPath) as! StampCell
        cell.backgroundColor = .blue200
        return cell
    }
}
