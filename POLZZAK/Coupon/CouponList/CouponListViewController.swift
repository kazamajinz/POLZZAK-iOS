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
        static let collectionViewNotLinkContentInset = UIEdgeInsets(top: notLinkContentInset, left: 0, bottom: notLinkContentInset, right: 0)
        static let groupSizeWidth: CGFloat = deviceWidth - 52.0
        static let groupSizeHeight: CGFloat = groupSizeWidth * 180.0 / 323.0
        static let notLinkGroupSizeHeight: CGFloat = groupSizeWidth * 512.0 / 323.0
        static let contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 26, bottom: 8, trailing: 26)
        static let interGroupSpacing: CGFloat = 15.0
        static let interSectionSpacing: CGFloat = 32.0
        static let headerViewHeight: CGFloat = 42.0
        static let filterHeight: CGFloat = 74.0
        static let headerTabHeight: CGFloat = 61.0
        static let notLinkContentInset: CGFloat = 28.0
        
        static let tabTitles = ["선물 전", "선물 완료"]
        static let placeHolderLabelText = "와 연동되면\n쿠폰함이 열려요!"
    }
    
    private var toast: Toast?
    
    private let viewModel = CouponListViewModel(repository: CouponDataRepository())
    private var cancellables = Set<AnyCancellable>()
    
    private let filterView = CouponFilterView()
    private let couponSkeletonView = CouponSkeletonView()
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
    
    private lazy var couponCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout(spacing: Constants.interSectionSpacing))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = Constants.collectionViewContentInset
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(CouponHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CouponHeaderView.reuseIdentifier)
        collectionView.register(CouponFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CouponFooterView.reuseIdentifier)
        collectionView.register(CouponEmptyCell.self, forCellWithReuseIdentifier: CouponEmptyCell.reuseIdentifier)
        collectionView.register(InprogressCouponCell.self, forCellWithReuseIdentifier: InprogressCouponCell.reuseIdentifier)
        collectionView.register(CompletedCouponCell.self, forCellWithReuseIdentifier: CompletedCouponCell.reuseIdentifier)
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
        
        [couponCollectionView, filterView, headerView, couponSkeletonView].forEach {
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
        
        couponCollectionView.snp.makeConstraints {
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
            .filter { [weak self] data in
                if (self?.viewModel.dataChanged.value) != nil {
                    self?.viewModel.dataChanged.value = nil
                    return false
                }

                if (self?.viewModel.dataDeleted.value) != nil {
                    self?.viewModel.dataDeleted.value = nil
                    return false
                }
                return self?.viewModel.isSkeleton.value == false
            }
            .map { array -> Bool in
                return array.isEmpty
            }
            .sink { [weak self] bool in
                self?.tabViews.setTouchInteractionEnabled(true)
                self?.handleEmptyView(for: bool)
                self?.updateFilterView()
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.filterType
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterType in
                self?.updateLayout(for: filterType)
                self?.updateFilterView()
            }
            .store(in: &cancellables)
        
        viewModel.dataChanged
                .receive(on: DispatchQueue.main)
                .sink { [weak self] indexPath in
                    if let indexPath {
                        self?.collectionView.reloadItems(at: [indexPath])
                    }
                }
                .store(in: &cancellables)

        viewModel.dataDeleted
                .receive(on: DispatchQueue.main)
                .sink { [weak self] indexPath in
                    if let indexPath {
                        self?.collectionView.performBatchUpdates({
                            self?.collectionView.deleteItems(at: [indexPath])
                            self?.collectionView.reloadSections(IndexSet(integer: indexPath.section))
                        }, completion: nil)
                    }
                }
                .store(in: &cancellables)
        
        viewModel.showErrorAlertSubject
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] error in
                self?.toast = Toast(type: .qatest(error.localizedDescription))
                self?.toast?.show()
                print("error", error.localizedDescription)
            }
            .store(in: &cancellables)
    }
    
    private func updateLayout(for filterType: FilterType) {
        switch filterType {
        case .all:
            filterView.handleAllFilterButtonTap()
        case .section(let memberId):
            guard let section = viewModel.sectionOfMember(with: memberId) else { return }
            let family = viewModel.dataList.value[section].family
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
        let newLayout = createLayout(spacing: Constants.interSectionSpacing)
        couponCollectionView.setCollectionViewLayout(newLayout, animated: false)
        couponCollectionView.reloadData()
    }
    
    private func handleSkeletonView(for bool: Bool) {
        if true == bool {
            viewModel.fetchCouponListAPI(isFirst: true)
            couponSkeletonView.showSkeletonView()
        } else {
            tabViews.initTabViews()
            customRefreshControl.isStartRefresh = true
            couponSkeletonView.hideSkeletonView()
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
            collectionView.contentInset = Constants.collectionViewNotLinkContentInset
            customRefreshControl.initialContentOffsetY = Constants.notLinkContentInset
            customRefreshControl.updateTopPadding(to: -Constants.headerViewHeight)
        } else {
            if viewModel.filterType.value == .none {
                viewModel.filterType.send(.all)
            }
            
            collectionView.contentInset = Constants.collectionViewContentInset
            customRefreshControl.initialContentOffsetY = Constants.filterHeight
            customRefreshControl.updateTopPadding(to: -Constants.headerTabHeight)
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
        
        if case let .section(memberID) = viewModel.filterType.value {
            guard let section = viewModel.sectionOfMember(with: memberID) else { return }
            bottomSheet.selectedIndex = section + 1
        }
        present(bottomSheet, animated: true, completion: nil)
    }
    
    private func guideButtonTapped() {
        let couponGuideViewController = CouponGuideViewController()
        navigationController?.present(couponGuideViewController, animated: false)
    }
}

extension CouponListViewController: UICollectionViewDataSource {
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
            cellCount = viewModel.dataList.value[section].coupons.count
        case .section(let memberId):
            if false == viewModel.dataList.value.isEmpty {
                guard let section = viewModel.sectionOfMember(with: memberId) else {
                    return 0
                }
                cellCount = viewModel.dataList.value[section].coupons.count
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
            if true == viewModel.dataList.value[indexPath.section].coupons.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        case .section(let memberID):
            guard let section = viewModel.sectionOfMember(with: memberID) else {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
            
            if true == viewModel.dataList.value[section].coupons.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        case .none:
            return dequeueNotLinkCell(in: collectionView)
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CouponHeaderView.reuseIdentifier, for: indexPath) as! CouponHeaderView
            if false == viewModel.dataList.value.isEmpty {
                let family = viewModel.dataList.value[indexPath.section].family
                headerView.configure(to: family, type: viewModel.userType)
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CouponFooterView.reuseIdentifier, for: indexPath) as! CouponFooterView
            let totalCount = viewModel.dataList.value[indexPath.section].coupons.count
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
    
    private func dequeueEmptyCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponEmptyCell.reuseIdentifier, for: indexPath) as! CouponEmptyCell
        return cell
    }
    
    private func dequeueCompletedCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedCouponCell.reuseIdentifier, for: indexPath) as! CompletedCouponCell
        switch viewModel.filterType.value {
        case .all:
            let couponData = viewModel.dataList.value[indexPath.section].coupons[indexPath.row]
            cell.configure(with: couponData)
        case .section(let memberId):
            guard let section = viewModel.sectionOfMember(with: memberId) else {
                return UICollectionViewCell()
            }
            let couponData = viewModel.dataList.value[section].coupons[indexPath.row]
            cell.configure(with: couponData)
        case .none:
            //TODO: - 처리
            break
        }
        return cell
    }
    
    private func dequeueInProgressCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressCouponCell.reuseIdentifier, for: indexPath) as! InprogressCouponCell
        cell.delegate = self
        switch viewModel.filterType.value {
        case .all:
            let couponData = viewModel.dataList.value[indexPath.section].coupons[indexPath.row]
            cell.configure(with: couponData, userType: viewModel.userType)
        case .section(let memberId):
            guard let section = viewModel.sectionOfMember(with: memberId) else {
                return UICollectionViewCell()
            }
            let couponData = viewModel.dataList.value[section].coupons[indexPath.row]
            cell.configure(with: couponData, userType: viewModel.userType)
        case .none:
            //TODO: - 처리
            break
        }
        return cell
    }
}


extension CouponListViewController: CollectionLayoutConfigurable {
    var collectionView: UICollectionView! {
        return self.couponCollectionView
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
}

extension CouponListViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        viewModel.resetPullToRefreshSubjects()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.didEndDraggingSubject.send()
        customRefreshControl.isStartRefresh = true
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
            let memberID = viewModel.dataList.value[index-1].family.memberID
            viewModel.filterType.send(.section(memberID))
        }
    }
}

extension CouponListViewController: InprogressCouponCellDelegate {
    func requestButtonTapped(cell: InprogressCouponCell) {
        guard viewModel.userType == .child else { return }
        if let indexPath = collectionView.indexPath(for: cell) {
            Task {
                let success = await viewModel.sendGiftRequest(indexPath: indexPath)
                if success {
                    cell.selectedRequestButton()
                }
            }
        }
    }
    
    func confirmButtonTapped(cell: InprogressCouponCell) {
        guard viewModel.userType == .child else { return }
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        guard let convertIndexPath = viewModel.convertIndexPath(indexPath) else { return }
        let confirmAlert = CouponReceiveAlertView()
        let dataList = viewModel.dataList.value
        
        let title = dataList[convertIndexPath.section].coupons[convertIndexPath.row].reward
        confirmAlert.titleLabel.text = title
        
        confirmAlert.secondButtonAction = { [weak self] in
            guard let self = self else { return }
            Task {
                await self.viewModel.sendGiftReceive(indexPath: convertIndexPath)
                confirmAlert.dismiss(animated: false, completion: nil)
            }
        }
        present(confirmAlert, animated: false)
    }
}
