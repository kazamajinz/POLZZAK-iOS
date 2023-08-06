//
//  CouponViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/28.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

final class CouponListViewController: UIViewController {
    private let viewModel = CouponListViewModel()
    private var inprogressDataSource: InprogressCouponCollectionViewDataSource
    private var completedDataSource: CompletedCouponCollectionViewDataSource
    var cancellables = Set<AnyCancellable>()
    
    private var initialContentOffsetY: Double = 74.0
    private var headerTabHeight: Double = 44.0
    private var filterTopPadding: Double = -23.0
    private var refreshPadding: Double = -84.0
    private let inprogressRefreshControl = CustomRefreshControl(topPadding: -20)
    private let completedRefreshControl = CustomRefreshControl(topPadding: -20)
    private let deviceWidth = UIApplication.shared.width
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews()
        tabViews.tabTitles = ["선물 전", "선물 완료"]
        return tabViews
    }()
    
    private let inprogressFilterView = FilterView()
    private let completedFilterView = FilterView()
    
    private let filterButtonView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private lazy var inprogressCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: inprogressCreateLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: initialContentOffsetY, left: 0, bottom: 32, right: 0)
        
        inprogressRefreshControl.observe(scrollView: collectionView)
        collectionView.refreshControl = inprogressRefreshControl
        
        collectionView.dataSource = inprogressDataSource
        collectionView.delegate = self
        
        collectionView.register(CouponHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CouponHeaderView.reuseIdentifier)
        collectionView.register(CouponFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CouponFooterView.reuseIdentifier)
        collectionView.register(CouponEmptyCell.self, forCellWithReuseIdentifier: CouponEmptyCell.reuseIdentifier)
        collectionView.register(InprogressCouponCell.self, forCellWithReuseIdentifier: InprogressCouponCell.reuseIdentifier)
        return collectionView
    }()
    
    private lazy var completedCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: completedCreateLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isHidden = true
        collectionView.contentInset = UIEdgeInsets(top: initialContentOffsetY, left: 0, bottom: 32, right: 0)
        
        completedRefreshControl.observe(scrollView: collectionView)
        collectionView.refreshControl = completedRefreshControl
        
        collectionView.dataSource = completedDataSource
        collectionView.delegate = self
        
        collectionView.register(CouponHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CouponHeaderView.reuseIdentifier)
        collectionView.register(CouponFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CouponFooterView.reuseIdentifier)
        collectionView.register(CouponEmptyCell.self, forCellWithReuseIdentifier: CouponEmptyCell.reuseIdentifier)
        collectionView.register(CompletedCouponCell.self, forCellWithReuseIdentifier: CompletedCouponCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        inprogressDataSource = InprogressCouponCollectionViewDataSource(viewModel: viewModel)
        completedDataSource = CompletedCouponCollectionViewDataSource(viewModel: viewModel)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setNavigation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setDelegate()
        setAction()
        bindViewModel()
    }
}

extension CouponListViewController {
    private func bindViewModel() {
        viewModel.$inprogressCouponListData
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.inprogressCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$completedCouponListData
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.completedCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$tabState
            .sink {
                [weak self] tabState in
                self?.applyTab(for: tabState)
                self?.updateInprogressFilterView()
            }
            .store(in: &cancellables)
        
        viewModel.$inprogressFilterType
            .receive(on: RunLoop.main)
            .sink { [weak self] filterType in
                self?.updateInprogressLayout(for: filterType)
                self?.updateInprogressFilterView()
                self?.applyInprogressSectionFilter()
            }
            .store(in: &cancellables)
        
        viewModel.$completedFilterType
            .receive(on: RunLoop.main)
            .sink { [weak self] filterType in
                self?.updateCompletedLayout(for: filterType)
                self?.updateCompletedFilterView()
                self?.applyCompletedSectionFilter()
            }
            .store(in: &cancellables)
    }
    
    private func setNavigation() {
        navigationController?.navigationBar.tintColor = .gray800
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let rightButtonImage = UIImage.informationButton?.withTintColor(.blue500)
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(guideButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        [inprogressFilterView, completedFilterView, inprogressCollectionView, completedCollectionView, filterButtonView, headerView].forEach {
            contentsView.addSubview($0)
        }
        
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
        
        headerView.addSubview(tabViews)
        
        tabViews.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        inprogressFilterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        completedFilterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        inprogressCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        completedCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        filterButtonView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(26)
            $0.width.equalTo(inprogressFilterView.filterStackView.snp.width)
        }
    }
    
    private func setDelegate() {
        tabViews.delegate = self
    }
    
    private func setAction() {
        let tapFilterButtonViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(filterButtonTapped))
        filterButtonView.addGestureRecognizer(tapFilterButtonViewRecognizer)
    }
    
    //TODO: - 테스트 코드, 삭제할것
    @objc private func filterButtonTapped() {
        
        let alertController = UIAlertController(title: "필터", message: "필터링해드림", preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "전체", style: .default) { [weak self] _ in
            self?.viewModel.inprogressFilterType = .all
        }
        
        let okAction2 = UIAlertAction(title: "쿼카 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            if self.viewModel.tabState == .completed {
                self.viewModel.completedFilterType = .section(0)
            } else {
                self.viewModel.inprogressFilterType = .section(0)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func updateInprogressLayout(for filterType: FilterType) {
        switch filterType {
        case .all:
            inprogressFilterView.handleAllFilterButtonTap()
        case .section(let index):
            let family = viewModel.inprogressCouponListData[index].family
            if viewModel.userType == .child {
                inprogressFilterView.handleChildSectionFilterButtonTap(with: family)
            } else {
                inprogressFilterView.handleParentSectionFilterButtonTap(with: family)
            }
        }
    }
    
    private func updateCompletedLayout(for filterType: FilterType) {
        switch filterType {
        case .all:
            completedFilterView.handleAllFilterButtonTap()
        case .section(let index):
            let family = viewModel.completedCouponListData[index].family
            if viewModel.userType == .child {
                completedFilterView.handleChildSectionFilterButtonTap(with: family)
            } else {
                completedFilterView.handleParentSectionFilterButtonTap(with: family)
            }
        }
    }
    
    private func applyTab(for tabState: TabState) {
        let bool = tabState == .completed
        inprogressCollectionView.isHidden = bool
        inprogressFilterView.isHidden = bool
        completedCollectionView.isHidden = !bool
        completedFilterView.isHidden = !bool
    }
    
    private func updateInprogressFilterView() {
        let currentOffset = inprogressCollectionView.contentOffset.y
        let distance = initialContentOffsetY + currentOffset
        let newY = max(headerTabHeight - distance, filterTopPadding)
        
        if distance >= 0 {
            inprogressFilterView.frame.origin.y = newY
            filterButtonView.frame.origin.y = newY + 24
        } else {
            inprogressFilterView.frame.origin.y = headerTabHeight
            filterButtonView.frame.origin.y = headerTabHeight + 24
        }
    }
    
    private func updateCompletedFilterView() {
        let currentOffset = completedCollectionView.contentOffset.y
        let distance = initialContentOffsetY + currentOffset
        let newY = max(headerTabHeight - distance, filterTopPadding)
        
        if distance >= 0 {
            completedFilterView.frame.origin.y = newY
            filterButtonView.frame.origin.y = newY + 24
        } else {
            completedFilterView.frame.origin.y = headerTabHeight
            filterButtonView.frame.origin.y = headerTabHeight + 24
        }
    }
    
    private func applyInprogressSectionFilter() {
        let newLayout = inprogressCreateLayout()
        inprogressCollectionView.setCollectionViewLayout(newLayout, animated: false)
    }
    
    private func applyCompletedSectionFilter() {
        let newLayout = completedCreateLayout()
        completedCollectionView.setCollectionViewLayout(newLayout, animated: false)
    }
    
    
    @objc private func guideButtonClicked() {
        let couponGuideViewController = CouponGuideViewController()
        present(couponGuideViewController, animated: false)
    }
}

extension CouponListViewController: UICollectionViewDelegateFlowLayout {
    func inprogressCreateLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 32
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSizeWidth = self.deviceWidth - 52
            let groupSizeHeigt = groupSizeWidth * 180 / 323
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(groupSizeWidth), heightDimension: .estimated(groupSizeHeigt))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 26, bottom: 8, trailing: 26)
            
            if self.viewModel.inprogressCouponListData[sectionIndex].coupons.isEmpty {
                section.boundarySupplementaryItems = [sectionHeader]
            } else {
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                
                if self.viewModel.inprogressFilterType == .all {
                    section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
                    section.orthogonalScrollingBehavior = .groupPaging
                } else {
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 26)
                }
                
            }
            
            section.interGroupSpacing = 15
            section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, _ in
                if let sectionIndex = visibleItems.last?.indexPath.section,
                   let footerView = self?.inprogressCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: sectionIndex)) as? CouponFooterView {
                    
                    if point.x < 0 {
                        return
                    }
                    
                    let cellSizeWidth = groupSizeWidth + 15
                    if Double(point.x).truncatingRemainder(dividingBy: Double(cellSizeWidth)) == 0.0 {
                        let currentCount = Int(Double(point.x) / Double(cellSizeWidth)) + 1
                        footerView.updateCurrentCount(with: currentCount)
                    }
                }
            }
            return section
        }, configuration: config)
        
        return layout
    }
    
    func completedCreateLayout() -> UICollectionViewLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 32
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: { [weak self] (sectionIndex, environment) -> NSCollectionLayoutSection? in
            guard let self = self else {
                return nil
            }
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSizeWidth = self.deviceWidth - 52
            let groupSizeHeigt = groupSizeWidth * 180 / 323
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(groupSizeWidth), heightDimension: .estimated(groupSizeHeigt))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem( layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 26, bottom: 8, trailing: 26)
            
            if self.viewModel.completedCouponListData[sectionIndex].coupons.isEmpty {
                section.boundarySupplementaryItems = [sectionHeader]
            } else {
                let footerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(20))
                let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: footerSize, elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
                
                if self.viewModel.completedFilterType == .all {
                    section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
                    section.orthogonalScrollingBehavior = .groupPaging
                } else {
                    section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 26)
                }
                
            }
            
            section.interGroupSpacing = 15
            section.visibleItemsInvalidationHandler = { [weak self] visibleItems, point, _ in
                if let sectionIndex = visibleItems.last?.indexPath.section,
                   let footerView = self?.completedCollectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: IndexPath(item: 0, section: sectionIndex)) as? CouponFooterView {
                    
                    if point.x < 0 {
                        return
                    }
                    
                    let cellSizeWidth = groupSizeWidth + 15
                    if Double(point.x).truncatingRemainder(dividingBy: Double(cellSizeWidth)) == 0.0 {
                        let currentCount = Int(Double(point.x) / Double(cellSizeWidth)) + 1
                        footerView.updateCurrentCount(with: currentCount)
                    }
                }
            }
            return section
        }, configuration: config)
        
        return layout
    }
}

extension CouponListViewController: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        viewModel.tabState == .completed ? self.completedRefreshControl.endRefreshing() : self.inprogressRefreshControl.endRefreshing()
        
    }
}

extension CouponListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(DetailBoardViewController(stampSize: .size20), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewModel.tabState == .completed ? updateCompletedFilterView() : updateInprogressFilterView()
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
