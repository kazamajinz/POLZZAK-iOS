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
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeight = UIScreen.main.bounds.height
    
    private var stampBoardState: StampBoardState = .unknown {
        didSet {
            collectionView.reloadData()
            setTabButton()
            updateLayout()
            DispatchQueue.main.async {
                self.updateFrames()
            }
        }
    }
    
    private var stampFilter: StampFilter = .all {
        didSet {
            updateMemberLabel()
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
    private let filterStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        return stackView
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()
    
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "전체", textColor: .gray800, font: .title4, textAlignment: .left)
        return label
    }()
    
    private let filterImageView: UIButton = {
        let imageView = UIButton()
        imageView.setImage(.filterButton, for: .normal)
        return imageView
    }()
    
    private let filterButtonView: UIView = {
        let view = UIView()
        return view
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
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: initialContentOffsetY, left: 0, bottom: 0, right: 0)
        
        customRefreshControl.observe(scrollView: collectionView)
        collectionView.refreshControl = customRefreshControl
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(StampBoardHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StampBoardHeaderView.reuseIdentifier)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.reuseIdentifier)
        collectionView.register(InprogressStampBoardCell.self, forCellWithReuseIdentifier: InprogressStampBoardCell.reuseIdentifier)
        collectionView.register(CompletedStampBoardCell.self, forCellWithReuseIdentifier: CompletedStampBoardCell.reuseIdentifier)
        
        return collectionView
    }()
    
    //MARK: - init
    init(userInformations: [UserInformation]) {
        //TODO: 테스트 데이터, 삭제할것
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
        
        //TODO: 테스트 데이터, 삭제할것
        stampFilter = .all
        stampBoardState = .inProgressAndAll
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
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
        }
        
        inProgressUnderlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        [completedTabLabel, completedUnderlineView].forEach {
            completedTabView.addSubview($0)
        }
        
        completedTabLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(4)
            $0.centerX.equalToSuperview()
        }
        
        completedUnderlineView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        //MARK: - 전체 UI
        view.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        //MARK: - contents UI
        [filterStackView, collectionView, addStampBoardButton, filterButtonView, headerTabStackView].forEach {
            contentsView.addSubview($0)
        }
        
        headerTabStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        filterStackView.snp.makeConstraints {
            $0.top.equalTo(headerTabStackView.snp.bottom)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(74)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerTabStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        addStampBoardButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        
        filterButtonView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(26)
            $0.width.equalTo(filterStackView.snp.width)
        }
        
        //MARK: - filter UI
        [nameStackView, filterImageView].forEach {
            filterStackView.addArrangedSubview($0)
        }
        
        [filterLabel].forEach {
            nameStackView.addArrangedSubview($0)
        }
    }
    
    private func setAction() {
        let tapInProgressTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(inProgressTabButtonTapped))
        inProgressTabView.addGestureRecognizer(tapInProgressTabRecognizer)
        
        let tapCompletedTabRecognizer = UITapGestureRecognizer(target: self, action: #selector(completedTabButtonTapped))
        completedTabView.addGestureRecognizer(tapCompletedTabRecognizer)
        
        let tapFilterButtonViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        filterButtonView.addGestureRecognizer(tapFilterButtonViewRecognizer)
    }
    
    //MARK: - @objc
    @objc private func myConnectionsButtonClicked() {
        print("myConnections 버튼 클릭")
    }
    
    @objc private func inProgressTabButtonTapped() {
        if stampBoardState == .completedAndAll {
            stampBoardState = .inProgressAndAll
        } else if stampBoardState == .completedAndSection {
            stampBoardState = .inProgressAndSection
        }
    }
    
    @objc private func completedTabButtonTapped() {
        if stampBoardState == .inProgressAndAll {
            stampBoardState = .completedAndAll
        } else if stampBoardState == .inProgressAndSection {
            stampBoardState = .completedAndSection
        }
    }
    
    @objc private func filterButtonTapped() {
        
        //TODO: 테스트 코드, 삭제할것
        let alertController = UIAlertController(title: "필터", message: "필터링해드림", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "전체", style: .default) { [weak self] _ in
            self?.stampFilter = .all
            
            if self?.stampBoardState == .inProgressAndSection {
                self?.stampBoardState = .inProgressAndAll
            } else if self?.stampBoardState == .completedAndSection {
                self?.stampBoardState = .completedAndAll
            }
        }
        
        //섹션2
        let okAction2 = UIAlertAction(title: "해린맘2(섹션2번) 선택", style: .default) { [weak self] _ in
            let num = 2
            let nickname = self?.userInformations[num].partner.nickname ?? "전체"
            let section = StampSection(id: num, name: nickname, memberType: "조카")
            self?.stampFilter = .section(section)
            
            if self?.stampBoardState == .inProgressAndAll {
                self?.stampBoardState = .inProgressAndSection
            } else if self?.stampBoardState == .completedAndAll {
                self?.stampBoardState = .completedAndSection
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setTabButton() {
        switch stampBoardState {
            
        case .inProgressAndAll, .inProgressAndSection:
            inProgressTabLabel.textColor = .blue400
            inProgressUnderlineView.backgroundColor = .blue400
            completedTabLabel.textColor = .gray300
            completedUnderlineView.backgroundColor = .gray300
            
        case .completedAndAll, .completedAndSection:
            inProgressTabLabel.textColor = .gray300
            inProgressUnderlineView.backgroundColor = .gray300
            completedTabLabel.textColor = .blue400
            completedUnderlineView.backgroundColor = .blue400
            
        case .unknown:
            inProgressTabLabel.textColor = .gray300
            inProgressUnderlineView.backgroundColor = .gray300
            completedTabLabel.textColor = .gray300
            completedUnderlineView.backgroundColor = .gray300
        }
    }
    
    private func updateLayout() {
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: false)
    }
    
    private func getSection() -> Int {
        switch stampFilter {
        case .all:
            return -1
        case .section(let section):
            return section.id
        }
    }
    
    private func updateFrames() {
        let currentOffset = collectionView.contentOffset.y
        let distance = initialContentOffsetY + currentOffset
        let newY = max(headerTabHeight - distance, filterTopPadding)

        if distance >= 0 {
            filterStackView.frame.origin.y = newY
            filterButtonView.frame.origin.y = newY + 24
        } else {
            filterStackView.frame.origin.y = headerTabHeight
            filterButtonView.frame.origin.y = headerTabHeight + 24
        }
    }

    private func updateMemberLabel() {
        switch stampFilter {
            
        case .all:
            guard nameStackView.arrangedSubviews.count != 1 else {
                return
            }
            
            guard let firstSubView = nameStackView.arrangedSubviews.first else {
                return
            }
            
            firstSubView.removeFromSuperview()
            filterLabel.text = "전체"
            
        case .section(let stampSection):
            if nameStackView.arrangedSubviews.count == 2 {
                guard let firstSubView = nameStackView.arrangedSubviews.first else {
                    return
                }
                
                firstSubView.removeFromSuperview()
            }
            
            let view = MemberTypeView(with: stampSection.memberType)
            self.nameStackView.insertArrangedSubview(view, at: 0)
            filterLabel.text = stampSection.name
        }
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func createLayout() -> UICollectionViewLayout {
        let section: NSCollectionLayoutSection
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let collectionViewHeight = 180.0/600.0
        
        let collectionViewWidth = deviceWidth - 52 + 15
        
        switch stampBoardState {
        case .inProgressAndAll, .unknown:
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7.5, bottom: 0, trailing: 7.5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(collectionViewWidth), heightDimension: .estimated(collectionViewWidth * 377.0 / 323.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(28))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18.5, bottom: 32, trailing: 18.5)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = [sectionHeader]
            
        case .inProgressAndSection:
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7.5, bottom: 22, trailing: 7.5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension:  .fractionalWidth(1), heightDimension: .estimated(collectionViewWidth * 377.0 / 323.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 18.5, bottom: 0, trailing: 18.5)
            section = NSCollectionLayoutSection(group: group)
            
        case .completedAndAll:
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 7.5, bottom: 0, trailing: 7.5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(collectionViewWidth/deviceWidth), heightDimension: .fractionalHeight(collectionViewHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(28))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18.5, bottom: 32, trailing: 18.5)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = [sectionHeader]
            
        case .completedAndSection:
            let collectionViewHeight = 180.0/600.0
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7.5, bottom: 22, trailing: 7.5)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(collectionViewHeight))
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
            
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 18.5, bottom: 32, trailing: 18.5)
        }
        
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, _ in
            if let sectionIndex = visibleItems.last?.indexPath.section,
               let headerView = self?.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: sectionIndex)) as? StampBoardHeaderView {
                
                if point.x < 0 {
                    return
                }
                
                if Double(point.x).truncatingRemainder(dividingBy: Double(collectionViewWidth)) <= 1.0 {
                    let currentCount = Int(Double(point.x) / Double(collectionViewWidth)) + 1
                    headerView.updateCurrentCount(with: currentCount)
                }
            }
        }
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var sectionCount: Int
        
        switch stampBoardState {
        case .inProgressAndAll, .completedAndAll, .unknown:
            sectionCount = userInformations.count
        case .inProgressAndSection, .completedAndSection:
            return 1
        }
        
        return sectionCount == 0 ? 1 : sectionCount
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount: Int
        
        switch stampBoardState {
        case .inProgressAndAll, .unknown:
            cellCount = userInformations[section].unRewardedStampBoards.count
        case .inProgressAndSection:
            let num = getSection()
            cellCount = userInformations[num].unRewardedStampBoards.count
        case .completedAndAll:
            cellCount = userInformations[section].rewardedStampBoards.count
        case .completedAndSection:
            let num = getSection()
            cellCount = userInformations[num].rewardedStampBoards.count
        }
        
        return cellCount == 0 ? 1 : cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cellCount: Int
        
        switch stampBoardState {
        case .inProgressAndAll, .unknown:
            cellCount = userInformations[indexPath.section].unRewardedStampBoards.count
        case .inProgressAndSection:
            let num = getSection()
            cellCount = userInformations[num].unRewardedStampBoards.count
        case .completedAndAll:
            cellCount = userInformations[indexPath.section].rewardedStampBoards.count
        case .completedAndSection:
            let num = getSection()
            cellCount = userInformations[num].rewardedStampBoards.count
        }
        
        if cellCount == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as! EmptyCell
            var section: Int
            
            switch stampBoardState {
            case .inProgressAndAll, .completedAndAll, .unknown:
                section = indexPath.section
            case .inProgressAndSection, .completedAndSection:
                section = getSection()
            }
            
            let nickName = userInformations[section].partner.nickname
            cell.configure(nickName: nickName)
            return cell
        } else {
            switch stampBoardState {
            case .inProgressAndAll, .unknown:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressStampBoardCell.reuseIdentifier, for: indexPath) as! InprogressStampBoardCell
                let stampBoardSummary = userInformations[indexPath.section].unRewardedStampBoards[indexPath.row]
                cell.configure(with: stampBoardSummary)
                return cell
            case .inProgressAndSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressStampBoardCell.reuseIdentifier, for: indexPath) as! InprogressStampBoardCell
                let num = getSection()
                let stampBoardSummary = userInformations[num].unRewardedStampBoards[indexPath.row]
                cell.configure(with: stampBoardSummary)
                return cell
            case .completedAndAll:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedStampBoardCell.reuseIdentifier, for: indexPath) as! CompletedStampBoardCell
                let stampBoardSummary = userInformations[indexPath.section].rewardedStampBoards[indexPath.row]
                cell.configure(with: stampBoardSummary)
                return cell
            case .completedAndSection:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedStampBoardCell.reuseIdentifier, for: indexPath) as! CompletedStampBoardCell
                let num = getSection()
                let stampBoardSummary = userInformations[num].rewardedStampBoards[indexPath.row]
                cell.configure(with: stampBoardSummary)
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampBoardHeaderView.reuseIdentifier, for: indexPath) as! StampBoardHeaderView
        
        switch stampBoardState {
        case .inProgressAndAll, .inProgressAndSection, .unknown:
            let memberType = userInformations[indexPath.section].partner.memberType
            let name = userInformations[indexPath.section].partner.nickname
            let totalCount = userInformations[indexPath.section].unRewardedStampBoards.count
            headerView.configure(memberType: memberType, nickName: name, totalCount: totalCount)
            
        case .completedAndAll, .completedAndSection:
            let memberType = userInformations[indexPath.section].partner.memberType
            let name = userInformations[indexPath.section].partner.nickname
            let totalCount = userInformations[indexPath.section].rewardedStampBoards.count
            headerView.configure(memberType: memberType, nickName: name, totalCount: totalCount)
        }
        
        return headerView
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFrames()
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.customRefreshControl.endRefreshing()
    }
}
