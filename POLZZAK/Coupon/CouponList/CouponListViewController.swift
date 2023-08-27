//
//  CouponListViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/28.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class CouponListViewController: UIViewController {
    enum Constants {
        static let deviceWidth = UIApplication.shared.width
        static let collectionViewContentInset = UIEdgeInsets(top: TabConstants.initialContentOffsetY, left: 0, bottom: 32, right: 0)
        static let groupSizeWidth: CGFloat = deviceWidth - 52.0
        static let groupSizeHeight: CGFloat = groupSizeWidth * 180.0 / 323.0
        static let contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 26, bottom: 8, trailing: 26)
        static let interGroupSpacing: CGFloat = 15.0
        static let interSectionSpacing: CGFloat = 32.0
        static let headerViewHeight: CGFloat = 42.0
        static let filterHeight: CGFloat = 74.0
        
        static let tabTitles = ["선물 전", "선물 완료"]
        static let placeHolderLabelText = "와 연동되면\n쿠폰함이 열려요!"
    }
    
    private let viewModel = CouponListViewModel()
    private var dataSource: CouponCollectionViewDataSource
    private var cancellables = Set<AnyCancellable>()
    
    private let customRefreshControl = CustomRefreshControl()
    private let filterView = CouponFilterView()
    private let fullLoadingView = FullLoadingView()
    private let couponSkeletonView = CouponSkeletonView()
    
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
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = Constants.collectionViewContentInset
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        collectionView.register(CouponHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CouponHeaderView.reuseIdentifier)
        collectionView.register(CouponFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CouponFooterView.reuseIdentifier)
        collectionView.register(CouponEmptyCell.self, forCellWithReuseIdentifier: CouponEmptyCell.reuseIdentifier)
        collectionView.register(InprogressCouponCell.self, forCellWithReuseIdentifier: InprogressCouponCell.reuseIdentifier)
        collectionView.register(CompletedCouponCell.self, forCellWithReuseIdentifier: CompletedCouponCell.reuseIdentifier)
        
        customRefreshControl.observe(scrollView: collectionView)
        collectionView.refreshControl = customRefreshControl
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        dataSource = CouponCollectionViewDataSource(viewModel: viewModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
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

extension CouponListViewController {
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
        
        [collectionView, filterView, headerView, emptyView, couponSkeletonView].forEach {
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
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.filterHeight)
        }
        
        couponSkeletonView.snp.makeConstraints {
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
        self.navigationController?.navigationBar.tintColor = .blue500
        let rightButtonImage = UIImage.informationButton?.withRenderingMode(.alwaysTemplate)
        let rightBarButtonItem = UIBarButtonItem(image: rightButtonImage, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        rightBarButtonItem.tapPublisher
            .sink { [weak self] _ in
                self?.guideButtonTapped()
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
            filterView.handleAllFilterButtonTap()
        case .section(let memberId):
            let idex = viewModel.indexOfMember(with: memberId)
            let family = viewModel.dataList.value[idex].family
            if viewModel.userType.value == .child {
                filterView.handleChildSectionFilterButtonTap(with: family)
            } else {
                filterView.handleParentSectionFilterButtonTap(with: family)
            }
        }
        Task {
            applySectionFilter()
        }
    }
    
    private func updateFilterView() {
        let currentOffset = collectionView.contentOffset.y
        let distance = TabConstants.initialContentOffsetY + currentOffset
        let newY = max(TabConstants.headerTopPadding - distance, TabConstants.filterTopPadding)
        
        if distance >= 0 {
            filterView.frame.origin.y = newY
        } else {
            filterView.frame.origin.y = TabConstants.headerTopPadding
        }
    }
    
    private func applySectionFilter() {
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: false)
        collectionView.reloadData()
    }
    
    private func handleSkeletonView(for bool: Bool) {
        if true == bool {
            viewModel.tempInprogressAPI(isFirst: true)
            couponSkeletonView.showSkeletonView()
        } else {
            tabViews.initTabViews()
            customRefreshControl.isRefresh = false
            couponSkeletonView.hideSkeletonView()
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
        filterView.isHidden = bool
        emptyView.isHidden = !bool
        
        if true == bool {
            //TODO: - userType 정의가 되면 변경
            emptyView.placeHolderLabel.text = (viewModel.userType.value == .child ? "아이" : "보호자") + Constants.placeHolderLabelText
            emptyView.addDashedBorder(borderColor: .gray300, spacing: 3, cornerRadius: 8)
        }
    }
    
    private func handleSelection(at indexPath: IndexPath) {
        guard let couponDetailViewModel = viewModel.selectItem(at: indexPath) else { return }
        let couponDetailViewController = CouponDetailViewController(viewModel: couponDetailViewModel)
        couponDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(couponDetailViewController, animated: false)
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
    
    @objc private func guideButtonTapped() {
        let couponGuideViewController = CouponGuideViewController()
        navigationController?.present(couponGuideViewController, animated: false)
    }
}

extension CouponListViewController: CollectionLayoutConfigurable {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = Constants.interSectionSpacing
        
        let layoutProvider: UICollectionViewCompositionalLayoutSectionProvider = { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            return self.createSection(for: sectionIndex)
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: layoutProvider, configuration: config)
    }
    
    func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(Constants.groupSizeWidth), heightDimension: .estimated(Constants.groupSizeHeight))
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

extension CouponListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.didEndDraggingSubject.send(true)
    }
}

extension CouponListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateFilterView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        handleSelection(at: indexPath)
    }
}

extension CouponListViewController: TabViewsDelegate {
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

extension CouponListViewController: FilterBottomSheetDelegate {
    func selectedItem(index: Int) {
        if index == 0 {
            viewModel.filterType.send(.all)
        } else {
            let memberId = viewModel.dataList.value[index-1].family.memberId
            viewModel.filterType.send(.section(memberId))
        }
    }
}
