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
        static let tabViewsArray = ["선물 전", "선물 완료"]
        static let placeHolderLabelText = "와 연동되면\n쿠폰함이 열려요!"
    }
    
    private let viewModel = CouponListViewModel()
    private var dataSource: CouponCollectionViewDataSource
    private var cancellables = Set<AnyCancellable>()
    private var isFirstChange: Bool = true
    
    private let customRefreshControl = CustomRefreshControl()
    private let filterView = FilterView()
    private let fullLoadingView = FullLoadingView()
    private let couponSkeletonView = CouponSkeletonView()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews()
        tabViews.tabTitles = Constants.tabViewsArray
        return tabViews
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let emptyView: CouponListEmptyView = {
        let emptyView = CouponListEmptyView()
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
            $0.height.equalTo(42)
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
            $0.height.equalTo(74)
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
        Publishers.CombineLatest(viewModel.apiFinishedLoadingSubject, viewModel.didEndDraggingSubject)
            .filter {
                return $0 && $1
            }
            .sink { [weak self] (apiFinished, didEndDragging) in
                self?.customRefreshControl.endRefreshing()
                self?.resetSubjects()
            }
            .store(in: &cancellables)
        
        viewModel.$isSkeleton
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.handleSkeletonView(for: bool)
            }
            .store(in: &cancellables)
        
        viewModel.$isCenterLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.handleLoadingView(for: bool)
            }
            .store(in: &cancellables)
        
        viewModel.$couponListData
            .filter { [weak self] _ in
                self?.viewModel.isSkeleton == false
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
        
        viewModel.$tabState
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink {
                [weak self] tabState in
                guard let self = self else { return }
                if self.isFirstChange && tabState == .inProgress {
                    self.isFirstChange = false
                    self.resetSubjects()
                    return
                }
                
                if tabState == .inProgress {
                    self.viewModel.tempInprogressAPI(for: true)
                } else {
                    self.viewModel.tempCompletedAPI(for: true)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$filterType
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
            let family = viewModel.couponListData[idex].family
            if viewModel.userType == .child {
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
    
    private func resetSubjects() {
        viewModel.apiFinishedLoadingSubject.send(false)
        viewModel.didEndDraggingSubject.send(false)
    }
    
    private func handleEmptyView(for bool: Bool) {
        filterView.isHidden = bool
        emptyView.isHidden = !bool
        
        if true == bool {
            //TODO: - userType 정의가 되면 변경
            emptyView.placeHolderLabel.text = (viewModel.userType == .child ? "아이" : "보호자") + Constants.placeHolderLabelText
            emptyView.addDashedBorder(borderColor: .gray300, spacing: 3, cornerRadius: 8)
        }
    }
    
    private func couponID(at indexPath: IndexPath) -> Int? {
        switch viewModel.filterType {
        case .all:
            guard false == viewModel.couponListData.isEmpty,
                  false == viewModel.couponListData[indexPath.section].coupons.isEmpty else {
                return nil
            }
            return viewModel.couponListData[indexPath.section].coupons[indexPath.row].couponID
        case .section(let memberId):
            let index = viewModel.couponListData.firstIndex { $0.family.memberId == memberId } ?? 0
            return viewModel.couponListData[index].coupons[indexPath.row].couponID
        }
    }
    
    private func handleSelection(at indexPath: IndexPath) {
        guard let id = couponID(at: indexPath) else { return }
        
        let couponDetailViewModel = CouponDetailViewModel(tabState: viewModel.tabState, couponID: id)
        let couponDetailViewController = CouponDetailViewController(viewModel: couponDetailViewModel)
        couponDetailViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(couponDetailViewController, animated: false)
    }
    
    
    @objc func handleRefresh() {
        if viewModel.tabState == .inProgress {
            viewModel.tempInprogressAPI()
        } else if viewModel.tabState == .completed {
            viewModel.tempCompletedAPI()
        }
        tabViews.setTouchInteractionEnabled(false)
    }
    
    @objc private func filterButtonTapped() {
        let data = viewModel.couponListData.map{ $0.family }
        let bottomSheet = FilterBottomSheetViewController(data: data)
        bottomSheet.delegate = self
        bottomSheet.modalPresentationStyle = .custom
        bottomSheet.transitioningDelegate = bottomSheet
        
        if case let .section(memberId) = viewModel.filterType {
            bottomSheet.selectedIndex = viewModel.indexOfMember(with: memberId) + 1
        }
        
        present(bottomSheet, animated: true, completion: nil)
    }
    
    @objc private func guideButtonTapped() {
        let couponGuideViewController = CouponGuideViewController()
        navigationController?.present(couponGuideViewController, animated: false)
    }
}

extension CouponListViewController: UICollectionViewDelegateFlowLayout {
    func createLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 32
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSizeWidth = Constants.deviceWidth - 52
            let groupSizeHeight = groupSizeWidth * 180 / 323
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(groupSizeWidth), heightDimension: .estimated(groupSizeHeight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 26, bottom: 8, trailing: 26)
            section.interGroupSpacing = 15
            
            configureSupplementaryItems(for: section, with: sectionIndex)
            handleVisibleItems(for: section, with: groupSizeWidth)
            
            return section
        }, configuration: config)
        
        return layout
    }
    
    private func configureSupplementaryItems(for section: NSCollectionLayoutSection, with sectionIndex: Int) {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let isDataNotEmpty = !viewModel.couponListData.isEmpty && !viewModel.couponListData[sectionIndex].coupons.isEmpty
        setBoundarySupplementaryItems(for: section, with: sectionHeader, isDataNotEmpty: isDataNotEmpty)
        configureContentInsetsAndScrolling(for: section)
    }
    
    private func setBoundarySupplementaryItems(for section: NSCollectionLayoutSection, with header: NSCollectionLayoutBoundarySupplementaryItem, isDataNotEmpty: Bool) {
        if isDataNotEmpty && viewModel.filterType == .all {
            let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
            section.boundarySupplementaryItems = [header, sectionFooter]
        } else if viewModel.filterType == .all {
            section.boundarySupplementaryItems = [header]
        }
    }
    
    private func configureContentInsetsAndScrolling(for section: NSCollectionLayoutSection) {
        viewModel.filterType != .all
        ? (section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 26))
        : (section.orthogonalScrollingBehavior = .groupPaging)
    }
    
    private func handleVisibleItems(for section: NSCollectionLayoutSection, with groupSizeWidth: CGFloat) {
        section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, _ in
            guard let self = self, point.x >= 0 else { return }
            
            if let sectionIndex = visibleItems.last?.indexPath.section,
               let footerView = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: sectionIndex)) as? CouponFooterView {
                
                let cellSizeWidth = groupSizeWidth + 15
                if Double(point.x).truncatingRemainder(dividingBy: Double(cellSizeWidth)) == 0.0 {
                    let currentCount = Int(Double(point.x) / Double(cellSizeWidth)) + 1
                    footerView.updateCurrentCount(with: currentCount)
                }
            }
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
            viewModel.preGiftTabSelected()
        case 1:
            viewModel.postGiftTabSelected()
        default:
            break
        }
    }
}

extension CouponListViewController: FilterBottomSheetDelegate {
    func selectedItem(index: Int) {
        if index == 0 {
            viewModel.filterType = .all
        } else {
            let memberId = viewModel.couponListData[index-1].family.memberId
            viewModel.filterType = .section(memberId)
        }
    }
}
