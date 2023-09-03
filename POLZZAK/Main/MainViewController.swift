//
//  MainViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class MainViewController: UIViewController {
    enum Constants {
        static let deviceWidth = UIApplication.shared.width
        static let collectionViewContentInset = UIEdgeInsets(top: TabConstants.initialContentOffsetY, left: 0, bottom: 32, right: 0)
        static let groupSizeWidth: CGFloat = deviceWidth - 52.0
        static let inprogressGroupSizeHeight: CGFloat = groupSizeWidth * 377.0 / 323.0
        static let completedGroupSizeHeight: CGFloat = groupSizeWidth * 180.0 / 323.0
        static let contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 26, bottom: 8, trailing: 26)
        static let interGroupSpacing: CGFloat = 15.0
        static let interSectionSpacing: CGFloat  = 32.0
        static let headerViewHeight: CGFloat  = 42.0
        static let filterHeight: CGFloat  = 74.0
        
        static let tabTitles = ["진행중", "완료"]
        static let placeHolderLabelText = "와 연동되면\n도장판을 만들 수 있어요!"
    }
    
    private let viewModel = StampBoardViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private let customRefreshControl = CustomRefreshControl()
    private let stampBoardFilterView = StampBoardFilterView()
    private let fullLoadingView = FullLoadingView()
    private let stampBoardSkeletonView = StampBoardSkeletonView()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews()
        tabViews.tabTitles = Constants.tabTitles
        return tabViews
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let emptyView: CollectionEmptyView = {
        let emptyView = CollectionEmptyView()
        emptyView.isHidden = true
        return emptyView
    }()
    
    private let addStampBoardButton: UIButton = {
        let button = UIButton()
        button.setImage(.addStampBoardButton, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private lazy var mainCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(spacing: Constants.interSectionSpacing))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = Constants.collectionViewContentInset
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(StampBoardHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: StampBoardHeaderView.reuseIdentifier)
        collectionView.register(StampBoardFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: StampBoardFooterView.reuseIdentifier)
        collectionView.register(EmptyCell.self, forCellWithReuseIdentifier: EmptyCell.reuseIdentifier)
        collectionView.register(InprogressStampBoardCell.self, forCellWithReuseIdentifier: InprogressStampBoardCell.reuseIdentifier)
        collectionView.register(CompletedStampBoardCell.self, forCellWithReuseIdentifier: CompletedStampBoardCell.reuseIdentifier)
        
        customRefreshControl.observe(scrollView: collectionView)
        collectionView.refreshControl = customRefreshControl
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setupNavigation()
        setupTabViews()
        setupAction()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateFilterView()
    }
}

extension MainViewController {
    private func setUI() {
        view.backgroundColor = .white
        
        [contentsView, fullLoadingView].forEach {
            view.addSubview($0)
        }
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        fullLoadingView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        [mainCollectionView, stampBoardFilterView, headerView, emptyView, addStampBoardButton, stampBoardSkeletonView].forEach {
            contentsView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.headerViewHeight)
        }
        
        headerView.addSubview(tabViews)
        
        tabViews.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        mainCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        stampBoardFilterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.filterHeight)
        }
        
        addStampBoardButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        
        stampBoardSkeletonView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview().inset(54)
        }
    }
    
    private func setupNavigation() {
        setNavigationBarStyle()
        self.navigationController?.navigationBar.tintColor = .gray800
        let rightBarButtonItem = UIBarButtonItem(image: .myConnectionsButton, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        rightBarButtonItem.tapPublisher
            .sink { [weak self] _ in
                self?.myConnectionsButtonTapped()
            }
            .store(in: &cancellables)
    }
    
    private func setupTabViews() {
        tabViews.delegate = self
    }
    
    private func setupAction() {
        let tapFilterButtonViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        stampBoardFilterView.filterStackView.addGestureRecognizer(tapFilterButtonViewRecognizer)
        customRefreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func bindViewModel() {
        viewModel.shouldEndRefreshing
            .sink { [weak self] in
                self?.customRefreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.isSkeleton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.handleSkeletonView(for: bool)
            }
            .store(in: &cancellables)
        
        viewModel.isCenterLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.handleLoadingView(for: bool)
            }
            .store(in: &cancellables)
        
        viewModel.dataList
            .filter { [weak self] _ in
                self?.viewModel.isSkeleton.value == false
            }
            .map { array -> Bool in
                return array.isEmpty
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.mainCollectionView.reloadData()
                self?.tabViews.setTouchInteractionEnabled(true)
                self?.handleEmptyView(for: bool)
                self?.updateFilterView()
            }
            .store(in: &cancellables)
        
        viewModel.filterType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterType in
                self?.updateLayout(for: filterType)
                self?.updateFilterView()
                
            }
            .store(in: &cancellables)
    }
    
    private func updateLayout(for filterType: FilterType) {
        switch filterType {
        case .all:
            stampBoardFilterView.handleAllFilterButtonTap()
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let family = viewModel.dataList.value[index].family
            if viewModel.userType.value == .child {
                stampBoardFilterView.handleChildSectionFilterButtonTap(with: family)
            } else {
                stampBoardFilterView.handleParentSectionFilterButtonTap(with: family)
            }
        }
        applySectionFilter()
    }
    
    private func applySectionFilter() {
        let newLayout = createLayout(spacing: Constants.interSectionSpacing)
        mainCollectionView.setCollectionViewLayout(newLayout, animated: false)
        mainCollectionView.reloadData()
    }
    
    private func updateFilterView() {
        let currentOffset = mainCollectionView.contentOffset.y
        let distance = TabConstants.initialContentOffsetY + currentOffset
        let newY = max(TabConstants.headerTopPadding - distance, TabConstants.filterTopPadding)
        
        if distance >= 0 {
            stampBoardFilterView.frame.origin.y = newY
        } else {
            stampBoardFilterView.frame.origin.y = TabConstants.headerTopPadding
        }
    }
    
    private func handleSkeletonView(for bool: Bool) {
        if true == bool {
            viewModel.tempInprogressAPI(isFirst: true)
            stampBoardSkeletonView.showSkeletonView()
        } else {
            tabViews.initTabViews()
            customRefreshControl.isRefresh = false
            stampBoardSkeletonView.hideSkeletonView()
            addStampBoardButton.isHidden = false
        }
    }
    
    private func handleLoadingView(for bool: Bool) {
        if true == bool {
            fullLoadingView.startLoading()
        } else {
            fullLoadingView.stopLoading()
        }
    }
    
    private func handleEmptyView(for bool: Bool) {
        stampBoardFilterView.isHidden = bool
        emptyView.isHidden = !bool
        
        if true == bool {
            //TODO: - userType 정의가 되면 변경
            emptyView.placeHolderLabel.text = (viewModel.userType.value == .child ? "아이" : "보호자") + Constants.placeHolderLabelText
            emptyView.addDashedBorder(borderColor: .gray300, spacing: 3, cornerRadius: 8)
        }
    }
    
    @objc func handleRefresh() {
        viewModel.loadData()
        tabViews.setTouchInteractionEnabled(false)
    }
    
    @objc private func filterButtonTapped() {
        let data = viewModel.dataList.value.map{ $0.family }
        let bottomSheet = FilterBottomSheetViewController(data: data)
        bottomSheet.delegate = self
        bottomSheet.modalPresentationStyle = .custom
        bottomSheet.transitioningDelegate = bottomSheet
        
        if case let .section(memberId) = viewModel.filterType.value {
            bottomSheet.selectedIndex = viewModel.indexOfMember(with: memberId) + 1
        }
        
        present(bottomSheet, animated: true, completion: nil)
    }
    
    private func myConnectionsButtonTapped() {
        let linkManagementViewController = LinkManagementViewController()
        linkManagementViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(linkManagementViewController, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch viewModel.filterType.value {
        case .all:
            return viewModel.dataList.value.count
        case .section:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount: Int = 0
        switch viewModel.filterType.value {
        case .all:
            cellCount = viewModel.dataList.value[section].stampBoardSummaries.count
        case .section(let memberId):
            if false == viewModel.dataList.value.isEmpty {
                let index = viewModel.indexOfMember(with: memberId)
                cellCount = viewModel.dataList.value[index].stampBoardSummaries.count
            } else {
                return 0
            }
        }
        
        return cellCount == 0 ? 1 : cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case .section(let memberId) = viewModel.filterType.value {
            let index = viewModel.indexOfMember(with: memberId)
            if true == viewModel.dataList.value[index].stampBoardSummaries.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        }
        
        if viewModel.filterType.value == .all {
            if true == viewModel.dataList.value[indexPath.section].stampBoardSummaries.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        }
        
        if true == viewModel.dataList.value.isEmpty {
            return dequeueEmptyCell(in: collectionView, at: indexPath)
        }
        
        switch viewModel.tabState.value {
        case .completed:
            return dequeueCompletedCouponCell(in: collectionView, at: indexPath)
        default:
            return dequeueInProgressCouponCell(in: collectionView, at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampBoardHeaderView.reuseIdentifier, for: indexPath) as! StampBoardHeaderView
            if false == viewModel.dataList.value.isEmpty {
                let family = viewModel.dataList.value[indexPath.section].family
                headerView.configure(to: family, type: viewModel.userType.value)
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampBoardFooterView.reuseIdentifier, for: indexPath) as! StampBoardFooterView
            let totalCount = viewModel.dataList.value[indexPath.section].stampBoardSummaries.count
            if totalCount != 0 {
                footerView.configure(with: totalCount)
            }
            
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
    
    private func dequeueEmptyCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponEmptyCell.reuseIdentifier, for: indexPath) as! CouponEmptyCell
        return cell
    }
    
    private func dequeueCompletedCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedStampBoardCell.reuseIdentifier, for: indexPath) as! CompletedStampBoardCell
        switch viewModel.filterType.value {
        case .all:
            let boardData = viewModel.dataList.value[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let boardData = viewModel.dataList.value[index].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        }
        return cell
    }
    
    private func dequeueInProgressCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressStampBoardCell.reuseIdentifier, for: indexPath) as! InprogressStampBoardCell
        switch viewModel.filterType.value {
        case .all:
            let boardData = viewModel.dataList.value[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let boardData = viewModel.dataList.value[index].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        }
        return cell
    }
}

extension MainViewController: CollectionLayoutConfigurable {
    var collectionView: UICollectionView! {
        return self.mainCollectionView
    }
    
    func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSizeHeight = viewModel.tabState.value == .inProgress ? Constants.inprogressGroupSizeHeight : Constants.completedGroupSizeHeight
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(Constants.groupSizeWidth), heightDimension: .estimated(groupSizeHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = Constants.contentInsets
        section.interGroupSpacing = Constants.interGroupSpacing
        
        let isDataNotEmpty = viewModel.isDataNotEmpty(forSection: sectionIndex)
        configureHeaderAndFooter(for: section, isDataNotEmpty: isDataNotEmpty, filterType: viewModel.filterType.value)
        handleVisibleItems(for: section, with: Constants.groupSizeWidth)
        
        return section
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.didEndDraggingSubject.send(true)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFilterView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailBoardViewController(stampSize: .size20), animated: true)
    }
}

extension MainViewController: TabViewsDelegate {
    func tabViews(_ tabViews: TabViews, didSelectTabAtIndex index: Int) {
        switch index {
        case 0:
            viewModel.setInProgressTab()
        case 1:
            viewModel.setCompletedTab()
        default:
            break
        }
    }
}

extension MainViewController: FilterBottomSheetDelegate {
    func selectedItem(index: Int) {
        if index == 0 {
            viewModel.filterType.send(.all)
        } else {
            let memberID = viewModel.dataList.value[index-1].family.memberID
            viewModel.filterType.send(.section(memberID))
        }
    }
}
