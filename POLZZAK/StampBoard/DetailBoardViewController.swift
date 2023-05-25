//
//  DetailBoardViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit

import SnapKit

class DetailBoardViewController: UIViewController {
    enum Constants {
        static let inset: CGFloat = 16
    }
    
    var missionList: [MissionListViewable] = [
        MissionData(missionNumber: 1, missionTitle: "a"),
        MissionData(missionNumber: 2, missionTitle: "b"),
        MissionData(missionNumber: 3, missionTitle: "c"),
        MissionData(missionNumber: 4, missionTitle: "d"),
        MissionData(missionNumber: 5, missionTitle: "e")
    ]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private let stampView: StampView
    private let missionListView = MissionListView(inset: Constants.inset)
    
    private var stampViewHeight: Constraint?
    private var missionListViewHeight: Constraint?
    
    init(stampSize: StampSize = .size40) {
        self.stampView = StampView(size: stampSize)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray100
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateHeightConstraints()
    }
}

extension DetailBoardViewController {
    private func configure() {
        configureLayout()
        configureView()
    }
    
    private func configureView() {
        stampView.isScrollEnabled = false
        missionListView.isScrollEnabled = false
        missionListView.missionListViewDataSource = self
        
        stampView.actionWhenUserTapMoreButton = { [weak self] in
            self?.updateHeightConstraints()
        }
        
        missionListView.actionWhenUserTapMoreButton = { [weak self] in
            self?.updateHeightConstraints()
        }
    }
    
    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(stampView)
        contentStackView.addArrangedSubview(missionListView)
        
        contentStackView.setCustomSpacing(16, after: stampView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        stampView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(Constants.inset)
            stampViewHeight = make.height.equalTo(200).constraint
        }
        
        missionListView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            missionListViewHeight = make.height.equalTo(100).constraint
        }
    }
    
    private func updateHeightConstraints() {
        view.layoutIfNeeded()
        
        let stampViewContentSizeHeight = stampView.collectionViewLayout.collectionViewContentSize.height
        let missionListViewContentSizeHeight = missionListView.collectionViewLayout.collectionViewContentSize.height
        
        stampViewHeight?.deactivate()
        missionListViewHeight?.deactivate()

        stampView.snp.makeConstraints { make in
            stampViewHeight = make.height.equalTo(stampViewContentSizeHeight).constraint
        }

        missionListView.snp.makeConstraints { make in
            // UICollectionViewCompositionalLayout.list에는 contentInset 설정할수가 없음
            // 디자인의 bottom contentInset이 있어서 + 15 해주었음
            missionListViewHeight = make.height.equalTo(missionListViewContentSizeHeight+15).constraint
        }
    }
}

extension DetailBoardViewController: MissionListViewDataSource {
    func missionListViewNumberOfItems() -> Int {
        return missionList.count
    }

    func missionListView(dataForItemAt indexPath: IndexPath) -> MissionListViewable {
        let data = missionList[indexPath.item]
        return data
    }
}

struct MissionData: MissionListViewable {
    let missionNumber: Int
    let missionTitle: String
}
