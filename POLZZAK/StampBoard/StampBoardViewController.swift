//
//  StampBoardViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit

import SnapKit

class StampBoardViewController: UIViewController {
    enum Constants {
        static let inset: CGFloat = 16
    }
    
    private lazy var missionListView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.getLayout())
        collectionView.register(MissionCell.self, forCellWithReuseIdentifier: MissionCell.reuseIdentifier)
        collectionView.register(MissionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MissionHeaderView.reuseIdentifier)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        missionListView.dataSource = self
        view.addSubview(missionListView)
        
        missionListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// TODO: - MissionListView 클래스 따로 만들어서 이게 DataSource 역할을 할 수 있게 가능?
// RxSwift써서, numberOfItem이랑 cell 그릴때 데이터는 입력받을 수 있도록..

extension StampBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MissionCell.reuseIdentifier, for: indexPath) as! MissionCell
        cell.titleLabel.text = "미션 제목이 들어가는 자리입니다.11"
        cell.updateInset(inset: Constants.inset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MissionHeaderView.reuseIdentifier, for: indexPath) as! MissionHeaderView
            header.updateInset(inset: Constants.inset)
            return header
        default:
            return UICollectionReusableView()
        }
    }
}

extension StampBoardViewController {
    func getLayout() -> UICollectionViewCompositionalLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.headerMode = .supplementary
        config.headerTopPadding = 0
        config.showsSeparators = false
        config.backgroundColor = .blue200
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        return layout
    }
}
