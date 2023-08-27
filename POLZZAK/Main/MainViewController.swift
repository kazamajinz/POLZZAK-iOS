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
    private var dataSource: StampBoardCollectionViewDataSource
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
    
    //MARK: - collectionView
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = Constants.collectionViewContentInset
        collectionView.dataSource = dataSource
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
    
    //MARK: - init
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        dataSource = StampBoardCollectionViewDataSource(viewModel: viewModel)
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
        setAction()
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
        
        [collectionView, stampBoardFilterView, headerView, emptyView, addStampBoardButton, stampBoardSkeletonView].forEach {
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
        
        collectionView.snp.makeConstraints {
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
    
    private func setAction() {
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
                self?.collectionView.reloadData()
                self?.tabViews.setTouchInteractionEnabled(true)
                self?.handleEmptyView(for: bool)
                Task {
                    self?.updateFilterView()
                }
            }
            .store(in: &cancellables)
        
        viewModel.filterType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterType in
                self?.updateLayout(for: filterType)
                Task {
                    self?.updateFilterView()
                }
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
        Task {
            applySectionFilter()
        }
    }
    
    private func applySectionFilter() {
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: false)
        collectionView.reloadData()
    }
    
    private func updateFilterView() {
        let currentOffset = collectionView.contentOffset.y
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
    
    //MARK: - @objc
    private func myConnectionsButtonTapped() {
        //TODO: - 보호자로 가정
        let linkManagementViewController = LinkManagementViewController(userType: .parent)
        linkManagementViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(linkManagementViewController, animated: true)
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
    
    private func updateLayout() {
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: false)
    }
}

extension MainViewController: CollectionLayoutConfigurable {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constants.interSectionSpacing
        
        let layoutProvider: UICollectionViewCompositionalLayoutSectionProvider = { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            return self?.createSection(for: sectionIndex)
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: layoutProvider, configuration: config)
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
    
    func handleVisibleItems(for section: NSCollectionLayoutSection, with groupSizeWidth: CGFloat) {
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, _ in
            self?.updateFooterViewBasedOnVisibleItems(visibleItems, with: groupSizeWidth, at: point)
        }
    }
    
    func updateFooterViewBasedOnVisibleItems(_ visibleItems: [NSCollectionLayoutVisibleItem], with groupSizeWidth: CGFloat, at point: CGPoint) {
        guard let sectionIndex = visibleItems.last?.indexPath.section, point.x >= 0,
              let footerView = collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: sectionIndex)) as? StampBoardFooterView else {
            return
        }
        
        let cellSizeWidth = groupSizeWidth + 15
        if CGFloat(point.x).truncatingRemainder(dividingBy: CGFloat(cellSizeWidth)) == 0.0 {
            let currentCount = Int(CGFloat(point.x) / CGFloat(cellSizeWidth)) + 1
            footerView.updateCurrentCount(with: currentCount)
        }
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
            let memberId = viewModel.dataList.value[index-1].family.memberId
            viewModel.filterType.send(.section(memberId))
        }
    }
}
