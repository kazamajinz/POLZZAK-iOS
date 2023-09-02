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
        MissionData(missionNumber: 1, missionTitle: "미션 제목이 들어가는 자리입니다."),
        MissionData(missionNumber: 2, missionTitle: "미션 제목이 들어가는 자리입니다."),
        MissionData(missionNumber: 3, missionTitle: "미션 제목이 들어가는 자리입니다."),
        MissionData(missionNumber: 4, missionTitle: "미션 제목이 들어가는 자리입니다."),
        MissionData(missionNumber: 5, missionTitle: "미션 제목이 들어가는 자리입니다.")
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
        stackView.alignment = .fill
        return stackView
    }()
    
    private let stampViewWrapper: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let nameView = DetailBoardNameView(horizontalInset: Constants.inset)
    private let compensationView = CompensationView(title: "아이유 2023 콘서트 티켓", horizontalInset: Constants.inset)
    
    let stampView: StampView
    let missionListView = MissionListView(horizontalInset: Constants.inset)
    
    var stampViewHeight: Constraint?
    var missionListViewHeight: Constraint?
    
    init(stampSize: StampSize) {
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
        nameView.setNameTitle(name: "제로의 도장판")
        nameView.setDayTitle(state: .completed(dayTaken: 3))
    }
}

extension DetailBoardViewController {
    private func configure() {
        configureLayout()
        configureView()
        setHeightConstraintDelegate()
        updateMissionListViewHeightConstraints()
        updateStampViewHeightConstraints()
    }
    
    private func configureView() {
        stampView.isScrollEnabled = false
        stampView.stampViewDelegate = self
        missionListView.isScrollEnabled = false
        missionListView.missionListViewDataSource = self
    }
    
    private func configureLayout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        stampViewWrapper.addSubview(stampView)
        
        [nameView,
         stampViewWrapper,
         missionListView,
         compensationView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        contentStackView.setCustomSpacing(16, after: stampViewWrapper)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        
        nameView.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
        
        stampView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.inset)
            stampViewHeight = make.height.equalTo(200).constraint
        }
        
        missionListView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            missionListViewHeight = make.height.equalTo(100).constraint
        }
    }
}

// MARK: - HeightConstraintDelegates

extension DetailBoardViewController: MissionListViewHeightConstraintDelegate, StampViewHeightConstraintDelegate {
    private func setHeightConstraintDelegate() {
        missionListView.heightConstraintDelegate = self
        stampView.heightConstraintDelegate = self
    }
}

// MARK: - MissionListViewDataSource

extension DetailBoardViewController: MissionListViewDataSource {
    func missionListView(numberOfItemsInSection section: Int) -> Int {
        return missionList.count
    }

    func missionListView(dataForItemAt indexPath: IndexPath) -> MissionListViewable {
        let data = missionList[indexPath.item]
        return data
    }
}

// MARK: - StampViewDelegate

extension DetailBoardViewController: StampViewDelegate {
    func stampView(_ stampView: StampView, didSelectItemAt indexPath: IndexPath) {
        let vc = StampAllowNavigationController()
        presentPanModal(vc)
    }
}

// MARK: - MissionListViewable

struct MissionData: MissionListViewable {
    let missionNumber: Int
    let missionTitle: String
}
