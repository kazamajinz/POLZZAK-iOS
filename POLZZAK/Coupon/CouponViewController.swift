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
import SkeletonView

final class CouponListViewController: UIViewController {
    private let viewModel = CouponListViewModel()
    private var dataSource: CouponCollectionViewDataSource
    private var cancellables = Set<AnyCancellable>()
    private var isFirstChange: Bool = true
    private let deviceWidth = UIApplication.shared.width
    
    private let customRefreshControl = CustomRefreshControl()
    private let filterView = FilterView()
    private let fullLoadingView = FullLoadingView()
    
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
    
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        return view
    }()
    
    private let emptyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .couponEmptyCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeHolderLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .gray700
        label.font = .body16Md
        label.textAlignment = .center
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: Constants.UI.initialContentOffsetY, left: 0, bottom: 32, right: 0)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.isSkeletonable = true
        
        collectionView.register(CouponHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CouponHeaderView.reuseIdentifier)
        collectionView.register(CouponFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CouponFooterView.reuseIdentifier)
        collectionView.register(CouponEmptyCell.self, forCellWithReuseIdentifier: CouponEmptyCell.reuseIdentifier)
        collectionView.register(CouponSkeletonCell.self, forCellWithReuseIdentifier: CouponSkeletonCell.reuseIdentifier)
        collectionView.register(InprogressCouponCell.self, forCellWithReuseIdentifier: InprogressCouponCell.reuseIdentifier)
        collectionView.register(CompletedCouponCell.self, forCellWithReuseIdentifier: CompletedCouponCell.reuseIdentifier)
        
        customRefreshControl.observe(scrollView: collectionView)
        collectionView.refreshControl = customRefreshControl
        return collectionView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        dataSource = CouponCollectionViewDataSource(viewModel: viewModel)
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
        
        [collectionView, filterView, headerView, emptyView].forEach {
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
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        filterView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        emptyView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(34)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview().inset(54)
        }
        
        [imageView, placeHolderLabel].forEach {
            emptyView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(153)
            $0.centerX.equalToSuperview()
        }
        
        placeHolderLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(32.24)
            $0.centerX.equalToSuperview()
        }
        
    }
    
    private func setNavigation() {
        navigationController?.navigationBar.tintColor = .gray800
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        let rightButtonImage = UIImage.informationButton?.withTintColor(.blue500)
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(guideButtonClicked))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    private func setDelegate() {
        tabViews.delegate = self
    }
    
    private func setAction() {
        let tapInprogressFilterButtonViewRecognizer = UITapGestureRecognizer(target: self, action: #selector(inprogressFilterButtonTapped))
        filterView.filterStackView.addGestureRecognizer(tapInprogressFilterButtonViewRecognizer)
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
            .filter { [weak self] _ in
                self?.viewModel.tabState != .unknown
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.handleLoadingView(for: bool)
            }
            .store(in: &cancellables)
        
        viewModel.$couponListData
            .filter { [weak self] _ in
                self?.viewModel.tabState != .unknown
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
                } else if tabState == .completed {
                    self.viewModel.tempCompletedAPI(for: true)
                } else {
                    self.viewModel.tempInprogressAPI()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$filterType
            .filter { $0 != .unknown }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] filterType in
                self?.updateLayout(for: filterType)
                Task {
                    self?.updateFilterView()
                }
            }
            .store(in: &cancellables)
    }
    
    @objc func handleRefresh() {
        if viewModel.tabState == .inProgress {
            viewModel.tempInprogressAPI()
        } else if viewModel.tabState == .completed {
            viewModel.tempCompletedAPI()
        }
        tabViews.setTouchInteractionEnabled(false)
    }

    
    private func handleSkeletonView(for bool: Bool) {
        tabViews.setTouchInteractionEnabled(!bool)
        if true == bool {
            filterView.showAnimatedSkeleton()
            collectionView.showAnimatedSkeleton()
        } else {
            tabViews.initTabViews()
            filterView.hideSkeleton()
            collectionView.hideSkeleton()
            customRefreshControl.isRefresh = false
        }
    }
    
    private func updateLayout(for filterType: FilterType) {
        switch filterType {
        case .all:
            filterView.handleAllFilterButtonTap()
        case .section(let index):
            let family = viewModel.couponListData[index].family
            if viewModel.userType == .child {
                filterView.handleChildSectionFilterButtonTap(with: family)
            } else {
                filterView.handleParentSectionFilterButtonTap(with: family)
            }
        case .unknown:
            return
        }
        Task {
            applySectionFilter()
        }
    }
    
    private func updateFilterView() {
        let currentOffset = collectionView.contentOffset.y
        let distance = Constants.UI.initialContentOffsetY + currentOffset
        let newY = max(Constants.UI.headerTopPadding - distance, Constants.UI.filterTopPadding)
        
        if distance >= 0 {
            filterView.frame.origin.y = newY
        } else {
            filterView.frame.origin.y = Constants.UI.headerTopPadding
        }
    }
    
    private func applySectionFilter() {
        let newLayout = createLayout()
        collectionView.setCollectionViewLayout(newLayout, animated: false)
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
            emptyView.addDashedBorder(borderColor: .gray300, spacing: 3, cornerRadius: 8)
            placeHolderLabel.text = (viewModel.userType == .child ? "아이" : "보호자") + "와 연동되면\n쿠폰함이 열려요!"
        }
    }
    
    //TODO: - 테스트 코드, 삭제할것
    @objc private func inprogressFilterButtonTapped() {
        let alertController = UIAlertController(title: "필터", message: "필터링해드림", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "전체", style: .default) { [weak self] _ in
            self?.viewModel.filterType = .all
        }
        let okAction2 = UIAlertAction(title: "쿼카 선택", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.filterType = .section(0)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func guideButtonClicked() {
        let couponGuideViewController = CouponGuideViewController()
        present(couponGuideViewController, animated: false)
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

            let groupSizeWidth = self.deviceWidth - 52
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
        } else if viewModel.tabState == .unknown || viewModel.filterType == .all {
            section.boundarySupplementaryItems = [header]
        }
    }

    private func configureContentInsetsAndScrolling(for section: NSCollectionLayoutSection) {
        if viewModel.tabState == .unknown {
            return
        }
        
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
