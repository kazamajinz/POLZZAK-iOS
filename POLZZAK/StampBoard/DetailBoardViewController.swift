//
//  DetailBoardViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import Combine
import UIKit

import PanModal
import SnapKit

final class DetailBoardViewController: UIViewController {
    enum Constants {
        static let inset: CGFloat = 16
    }
    
    private var cancellabels = Set<AnyCancellable>()
    private let viewModel: DetailBoardViewModel
    
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
    
    init(stampSize: StampSize, stampBoardID: Int) {
        self.stampView = StampView(size: stampSize)
        self.viewModel = DetailBoardViewModel(stampBoardID: stampBoardID)
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
}

extension DetailBoardViewController {
    private func configure() {
        configureLayout()
        configureView()
        configureBinding()
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
        
        contentStackView.setCustomSpacing(0, after: nameView)
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
    
    private func configureBinding() {
        compensationView.issuingTapPublisher
            .sink { [weak self] in
                let vc = IssueCouponBottomSheetViewController()
                self?.presentPanModal(vc)
            }
            .store(in: &cancellabels)
        
        viewModel.state.$stampBoardDetail
            .sink { [weak self] stampBoardDetail in
                guard let self, let stampBoardDetail else { return }
                
                nameView.setNameTitle(name: stampBoardDetail.name)
                nameView.setDayTitle(state: stampBoardDetail.status, dayPassed: stampBoardDetail.dayPassed)
                
                stampView.reloadData()
                missionListView.reloadData()
            }
            .store(in: &cancellabels)
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
        return viewModel.state.stampBoardDetail?.missions.count ?? 0
    }

    func missionListView(dataForItemAt indexPath: IndexPath) -> MissionListViewable? {
        let data = viewModel.state.stampBoardDetail?.missions[indexPath.item]
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
