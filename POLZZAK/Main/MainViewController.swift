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
        static let collectionViewContentInset = UIEdgeInsets(top: 74.0, left: 0, bottom: 32.0, right: 0)
        static let collectionViewNotLinkContentInset = UIEdgeInsets(top: notLinkContentInset, left: 0, bottom: notLinkContentInset, right: 0)
        static let groupSizeWidth: CGFloat = deviceWidth - 52.0
        static let inprogressGroupSizeHeight: CGFloat = groupSizeWidth * 377.0 / 323.0
        static let completedGroupSizeHeight: CGFloat = groupSizeWidth * 180.0 / 323.0
        static let notLinkGroupSizeHeight: CGFloat = groupSizeWidth * 512.0 / 323.0
        static let contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 26, bottom: 8, trailing: 26)
        static let interGroupSpacing: CGFloat = 15.0
        static let interSectionSpacing: CGFloat  = 32.0
        static let headerViewHeight: CGFloat  = 42.0
        static let filterHeight: CGFloat  = 74.0
        static let headerTabHeight: CGFloat = 61.0
        static let notLinkContentInset: CGFloat = 28.0
        
        static let tabTitles = ["진행중", "완료"]
    }
    
    private var toast: Toast?
    
    private let viewModel = StampBoardViewModel(repository: StampBoardsDataRepository())
    private var cancellables = Set<AnyCancellable>()
    
    private let filterView = BaseFilterView()
    private let stampBoardSkeletonView = StampBoardSkeletonView()
    private let fullLoadingView = FullLoadingView()
    
    private let customRefreshControl: CustomRefreshControl = {
        let refreshControl = CustomRefreshControl(topPadding: -Constants.headerTabHeight)
        refreshControl.initialContentOffsetY = Constants.filterHeight
        return refreshControl
    }()
    
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
        collectionView.register(InprogressStampBoardCell.self, forCellWithReuseIdentifier: InprogressStampBoardCell.Constants.reuseIdentifier)
        collectionView.register(CompletedStampBoardCell.self, forCellWithReuseIdentifier: CompletedStampBoardCell.reuseIdentifier)
        collectionView.register(NotLinkCell.self, forCellWithReuseIdentifier: NotLinkCell.reuseIdentifier)
        
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
        
        setupNavigation()
        setupUI()
        setupTabViews()
        setupAction()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Task {
            updateFilterView()
        }
    }
}

extension MainViewController {
    private func setupUI() {
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
        
        [mainCollectionView, filterView, headerView, addStampBoardButton, stampBoardSkeletonView].forEach {
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
        
        filterView.snp.makeConstraints {
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
        filterView.filterStackView.addGestureRecognizer(tapFilterButtonViewRecognizer)
        customRefreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        addStampBoardButton.tapPublisher
            .sink { [weak self] in
                let vc = NewStampBoardViewController()
                vc.modalPresentationStyle = .overFullScreen
                self?.present(vc, animated: true)
            }
            .store(in: &cancellables)
    }
    
    private func bindViewModel() {
        viewModel.shouldEndRefreshing
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                if true == bool {
                    self?.customRefreshControl.endRefreshing()
                    self?.viewModel.resetPullToRefreshSubjects()
                } else {
                    self?.customRefreshControl.endRefreshing()
                }
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
            .receive(on: DispatchQueue.main)
            .filter { [weak self] _ in
                self?.viewModel.isSkeleton.value == false
            }
            .map { array -> Bool in
                return array.isEmpty
            }
            .sink { [weak self] bool in
                self?.tabViews.setTouchInteractionEnabled(true)
                self?.handleEmptyView(for: bool)
                self?.updateFilterView()
                self?.mainCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.filterType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterType in
                self?.updateLayout(for: filterType)
                self?.updateFilterView()
            }
            .store(in: &cancellables)
        
        viewModel.showErrorAlertSubject
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { error in
                //TODO: - 에러처리 어떻게 할지 기획필요
            }
            .store(in: &cancellables)
    }
    
    private func updateLayout(for filterType: FilterType) {
        switch filterType {
        case .all:
            filterView.handleAllFilterButtonTap()
        case .section(let memberId):
            guard let index = viewModel.sectionOfMember(with: memberId) else { return }
            let family = viewModel.dataList.value[index].family
            if viewModel.userType == .child {
                filterView.handleChildSectionFilterButtonTap(with: family)
            } else {
                filterView.handleParentSectionFilterButtonTap(with: family)
            }
        case .none:
            break
        }
        applySectionFilter()
    }
    
    private func updateFilterView() {
        let currentOffset = mainCollectionView.contentOffset.y
        let distance = TabConstants.initialContentOffsetY + currentOffset
        let newY = max(TabConstants.headerTopPadding - distance, TabConstants.filterTopPadding)
        
        if distance >= 0 {
            filterView.frame.origin.y = newY
        } else {
            filterView.frame.origin.y = TabConstants.headerTopPadding
        }
    }
    
    private func applySectionFilter() {
        let newLayout = createLayout(spacing: Constants.interSectionSpacing)
        mainCollectionView.setCollectionViewLayout(newLayout, animated: false)
        mainCollectionView.reloadData()
    }
    
    private func handleSkeletonView(for bool: Bool) {
        if true == bool {
            viewModel.fetchStampBoardListAPI(isFirst: true)
            stampBoardSkeletonView.showSkeletonView()
        } else {
            tabViews.initTabViews()
            customRefreshControl.isStartRefresh = true
            stampBoardSkeletonView.hideSkeletonView()
            addStampBoardButton.isHidden = false
        }
    }
    
    private func handleLoadingView(for bool: Bool) {
        if true == bool {
            fullLoadingView.startLoading()
        } else {
            fullLoadingView.stopLoading()
            applySectionFilter()
        }
    }
    
    private func handleEmptyView(for bool: Bool) {
        filterView.isHidden = bool
        
        if bool == true {
            viewModel.filterType.send(.none)
            mainCollectionView.contentInset = Constants.collectionViewNotLinkContentInset
            customRefreshControl.initialContentOffsetY = Constants.notLinkContentInset
            customRefreshControl.updateTopPadding(to: -Constants.headerViewHeight)
        } else {
            if viewModel.filterType.value == .none {
                viewModel.filterType.send(.all)
            }
            
            mainCollectionView.contentInset = Constants.collectionViewContentInset
            customRefreshControl.initialContentOffsetY = Constants.filterHeight
            customRefreshControl.updateTopPadding(to: -Constants.headerTabHeight)
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
        
        if case let .section(memberID) = viewModel.filterType.value {
            guard let section = viewModel.sectionOfMember(with: memberID) else { return }
            bottomSheet.selectedIndex = section + 1
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
        case .none:
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
                guard let section = viewModel.sectionOfMember(with: memberId) else {
                    return 0
                }
                cellCount = viewModel.dataList.value[section].stampBoardSummaries.count
            } else {
                return 0
            }
        case .none:
            return 1
        }
        
        return cellCount == 0 ? 1 : cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.filterType.value {
        case .all:
            if true == viewModel.dataList.value[indexPath.section].stampBoardSummaries.isEmpty {
                let nickname = viewModel.dataList.value[indexPath.section].family.nickname
                return dequeueEmptyCell(in: collectionView, at: indexPath, with: nickname)
            }
        case .section(let memberID):
            guard let section = viewModel.sectionOfMember(with: memberID) else {
                return UICollectionViewCell()
            }
            
            if true == viewModel.dataList.value[section].stampBoardSummaries.isEmpty {
                let nickname = viewModel.dataList.value[section].family.nickname
                return dequeueEmptyCell(in: collectionView, at: indexPath, with: nickname)
            }
        case .none:
            return dequeueNotLinkCell(in: collectionView)
        }
        
        if true == viewModel.dataList.value.isEmpty {
            let nickname = viewModel.dataList.value[indexPath.section].family.nickname
            return dequeueEmptyCell(in: collectionView, at: indexPath, with: nickname)
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
                headerView.configure(to: family, type: viewModel.userType)
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
    
    private func dequeueNotLinkCell(in collectionView: UICollectionView) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotLinkCell.reuseIdentifier, for: IndexPath(row: 0, section: 0)) as! NotLinkCell
        //TODO: - UserType 변경되면 수정할것.
        cell.configure(with: viewModel.userType == .child ? "아이" : "보호자")
        return cell
    }
    
    private func dequeueEmptyCell(in collectionView: UICollectionView, at indexPath: IndexPath, with nickName: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmptyCell.reuseIdentifier, for: indexPath) as! EmptyCell
        cell.configure(with: nickName, tabState: viewModel.tabState.value, userType: viewModel.userType)
        return cell
    }
    
    private func dequeueInProgressCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressStampBoardCell.Constants.reuseIdentifier, for: indexPath) as! InprogressStampBoardCell
        switch viewModel.filterType.value {
        case .all:
            let boardData = viewModel.dataList.value[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            guard let section = viewModel.sectionOfMember(with: memberId) else {
                return UICollectionViewCell()
            }
            let boardData = viewModel.dataList.value[section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .none:
            //TODO: - 처리
            break
        }
        return cell
    }
    
    private func dequeueCompletedCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedStampBoardCell.reuseIdentifier, for: indexPath) as! CompletedStampBoardCell
        switch viewModel.filterType.value {
        case .all:
            let boardData = viewModel.dataList.value[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            guard let section = viewModel.sectionOfMember(with: memberId) else {
                return UICollectionViewCell()
            }
            let boardData = viewModel.dataList.value[section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .none:
            //TODO: - 처리
            break
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
        
        let groupSizeHeight: CGFloat
        if viewModel.filterType.value == .none {
            groupSizeHeight = Constants.notLinkGroupSizeHeight
        } else {
            groupSizeHeight = viewModel.tabState.value == .inProgress ? Constants.inprogressGroupSizeHeight : Constants.completedGroupSizeHeight
        }
        
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
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.resetPullToRefreshSubjects()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.didEndDraggingSubject.send()
        customRefreshControl.isStartRefresh = true
    }
}

extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFilterView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailBoardViewController(stampSize: .size20, stampBoardID: 1), animated: true)
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
