//
//  MainViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit
import SnapKit

final class MainViewController: UIViewController {
    
    //MARK: - let, var
    private var userInformations: [UserInformation]
    
    private var initialContentOffsetY: Double = 74.0
    private var headerTabHeight: Double = 44.0
    private var filterTopPadding: Double = -23.0
    private var refreshPadding: Double = -84.0
    private let customRefreshControl = CustomRefreshControl(topPadding: -20)
    
    private var stampBoardState: StampBoardState = .unknown {
        didSet {
            switch stampBoardState {
            case .inProgress:
                inProgressTabLabel.textColor = .blue400
                inProgressUnderlineView.backgroundColor = .blue400
                
                completedTabLabel.textColor = .gray300
                completedUnderlineView.backgroundColor = .gray300
                
            case .completed:
                inProgressTabLabel.textColor = .gray300
                inProgressUnderlineView.backgroundColor = .gray300
                
                completedTabLabel.textColor = .blue400
                completedUnderlineView.backgroundColor = .blue400
                
            case .unknown:
                inProgressTabLabel.textColor = .gray300
                inProgressUnderlineView.backgroundColor = .gray300
                
                completedTabLabel.textColor = .blue400
                completedUnderlineView.backgroundColor = .blue400
            }
            
            collectionView.reloadData()
            
            let newLayout = createLayout()
            collectionView.setCollectionViewLayout(newLayout, animated: false)
        }
    }
    
    //MARK: - headerTabStackView UI
    private let headerTabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private let inProgressTabView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let inProgressTabLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "진행 중", textColor: .gray300, font: .subtitle2, textAlignment: .center)
        return label
    }()
    
    private let inProgressUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    private let completedTabView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let completedTabLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "완료", textColor: .gray300, font: .subtitle2, textAlignment: .center)
        return label
    }()
    
    private let completedUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    //MARK: - filterView UI
    private let filterView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "전체", textColor: .gray800, font: .title4, textAlignment: .left)
        return label
    }()
    
    private let filterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .filterButton
        return imageView
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let addStampBoardButton: UIButton = {
        let button = UIButton()
        button.setImage(.addStampBoardButton, for: .normal)
        return button
    }()
    
    //MARK: - collectionView
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: initialContentOffsetY, left: 0, bottom: 0, right: 0)
        
        customRefreshControl.delegate = self
        customRefreshControl.observe(scrollView: collectionView)
        collectionView.refreshControl = customRefreshControl
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(InprogressStampBoardCell.self, forCellWithReuseIdentifier: InprogressStampBoardCell.reuseIdentifier)
        collectionView.register(CompletedStampBoardCell.self, forCellWithReuseIdentifier: CompletedStampBoardCell.reuseIdentifier)
        collectionView.register(StampBoardHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StampBoardHeaderView.reuseIdentifier)
        
        return collectionView
    }()
    
    //MARK: - init
    init(userInformations: [UserInformation]) {
        //테스트 데이터
        self.userInformations = userInformations
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigation()
        setAction()
        
        //테스트
        stampBoardState = .inProgress
    }
}

extension MainViewController {
    private func setNavigation() {
        navigationController?.navigationBar.tintColor = .gray800
        let rightButtonImage = UIImage.myConnectionsButton
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(myConnectionsButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        //MARK: - headerTabStackView UI
        [inProgressTabView, completedTabView].forEach {
            headerTabStackView.addArrangedSubview($0)
        }
        
        [inProgressTabLabel, inProgressUnderlineView].forEach {
            inProgressTabView.addSubview($0)
        }
        
        inProgressTabLabel.snp.makeConstraints {
            $0.top.equalTo(14)
            $0.bottom.equalTo(-4)
            $0.centerX.equalToSuperview()
        }
        
        inProgressUnderlineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        [completedTabLabel, completedUnderlineView].forEach {
            completedTabView.addSubview($0)
        }
        
        completedTabLabel.snp.makeConstraints {
            $0.top.equalTo(14)
            $0.bottom.equalTo(-4)
            $0.centerX.equalToSuperview()
        }
        
        completedUnderlineView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        //MARK: - 전체 UI
        view.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        //MARK: - contents UI
        [filterView, headerTabStackView, collectionView, addStampBoardButton].forEach {
            contentsView.addSubview($0)
        }
        
        headerTabStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(headerTabStackView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerTabStackView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addStampBoardButton.snp.makeConstraints {
            $0.trailing.equalTo(-16)
            $0.bottom.equalTo(-16)
        }
        
        //MARK: - filter UI
        [filterLabel, filterImageView].forEach {
            filterView.addSubview($0)
        }
        
        filterLabel.snp.makeConstraints {
            $0.top.equalTo(21)
            $0.leading.equalTo(16)
            $0.bottom.equalTo(-22)
        }
        
        filterImageView.snp.makeConstraints {
            $0.top.equalTo(filterLabel.snp.top).offset(3.5)
            $0.leading.equalTo(filterLabel.snp.trailing).offset(4)
            $0.bottom.equalTo(filterLabel.snp.bottom).offset(-3.5)
            $0.height.width.equalTo(24)
        }
    }
    
    func setAction() {
        let tapInProgressTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(inProgressTabButtonTapped))
        inProgressTabView.addGestureRecognizer(tapInProgressTabRecognizer)
        
        let tapCompletedTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(completedTabButtonTapped))
        completedTabView.addGestureRecognizer(tapCompletedTabRecognizer)
        
        let tapFilterRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        filterView.addGestureRecognizer(tapFilterRecognizer)
    }
    
    //MARK: - @objc
    @objc private func myConnectionsButtonClicked() {
        print("myConnections 버튼 클릭")
    }
    
    @objc private func inProgressTabButtonTapped() {
        stampBoardState = .inProgress
    }
    
    @objc private func completedTabButtonTapped() {
        stampBoardState = .completed
    }
    
    @objc private func filterButtonTapped() {
        print("filterButton 버튼 클릭")
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func createLayout() -> UICollectionViewLayout {
        switch stampBoardState {
        case .inProgress, .unknown:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let deviceWidth = UIScreen.main.bounds.width
            let deviceHeight = UIScreen.main.bounds.height
            let collcetcionViewWidth = deviceWidth - 46
            let collcetcionViewHeight = deviceHeight - 130 - 82 - 44
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(collcetcionViewWidth/deviceWidth),
                heightDimension: .fractionalHeight(collcetcionViewHeight/deviceHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 32, trailing: 12)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(28))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 11, bottom: 0, trailing: 11)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.boundarySupplementaryItems = [sectionHeader]
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
            
        case .completed:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let deviceWidth = UIScreen.main.bounds.width
            let collcetcionViewWidth = deviceWidth - 46
            let collcetcionViewHeight = 180.0/600.0
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(collcetcionViewWidth/deviceWidth),
                heightDimension: .fractionalHeight(collcetcionViewHeight)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(28))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 11, bottom: 32, trailing: 11)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.boundarySupplementaryItems = [sectionHeader]
            
            let layout = UICollectionViewCompositionalLayout(section: section)
            return layout
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return userInformations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch stampBoardState {
        case .inProgress:
            return userInformations[section].unRewardedStampBoards.count
        case .completed:
            return userInformations[section].rewardedStampBoards.count
        case .unknown:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch stampBoardState {
        case .inProgress, .unknown:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressStampBoardCell.reuseIdentifier, for: indexPath) as! InprogressStampBoardCell
            let stampBoardSummary = userInformations[indexPath.section].unRewardedStampBoards[indexPath.row]
            cell.configure(with: stampBoardSummary)
            return cell
            
        case .completed:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedStampBoardCell.reuseIdentifier, for: indexPath) as! CompletedStampBoardCell
            let stampBoardSummary = userInformations[indexPath.section].unRewardedStampBoards[indexPath.row]
            cell.configure(with: stampBoardSummary)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampBoardHeaderView.reuseIdentifier, for: indexPath) as! StampBoardHeaderView
        
        let name = userInformations[indexPath.section].partner.nickname
        let currentCount = indexPath.row + 1
        let totalCount = userInformations[indexPath.section].unRewardedStampBoards.count
        headerView.configure(nickName: name, currentCount: currentCount, totalCount: totalCount)
        
        return headerView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let distance = initialContentOffsetY + currentOffset
        let newY = max(headerTabHeight - distance, filterTopPadding)
        
        if distance >= 0 {
            filterView.frame.origin.y = newY
        } else {
            filterView.frame.origin.y = headerTabHeight
        }
    }
}

extension MainViewController: CustomRefreshControlDelegate {
    func didFinishDragging() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if true == self.customRefreshControl.isRefreshing {
                print("새로고침")
                self.customRefreshControl.endRefreshing()
            }
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        customRefreshControl.delegate?.didFinishDragging()
    }
}
