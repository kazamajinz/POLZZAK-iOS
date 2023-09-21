//
//  LinkManagementViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/09.
//

import UIKit
import SnapKit
import Combine

final class LinkManagementViewController: UIViewController {
    enum Constants {
        static let backButtonPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
    }
    
    private let viewModel = LinkManagementViewModel(repository: LinkManagementDataRepository())
    private var cancellables = Set<AnyCancellable>()
    
    private var toast: Toast?
    
    //MARK: - UI
    private var tableEmptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.label.setLabel(textColor: .gray700, font: .body3, textAlignment: .center)
        emptyView.imageView.image = .sittingCharacter
        emptyView.isHidden = true
        return emptyView
    }()
    
    private lazy var searchEmptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.topSpacing = 229
        emptyView.label.setLabel(text: "연동된 \(viewModel.userType.string)에게\n칭안 도장판을 만들어 줄 수 있어요", textColor: .gray500, font: .caption12Md, textAlignment: .center)
        emptyView.imageView.image = .searchImage
        emptyView.isHidden = true
        return emptyView
    }()
    private var searchResultView: SearchResultView = SearchResultView()
    private let fullLoadingView = FullLoadingView(backgroundColor: .white.withAlphaComponent(0.4))
    
    private let searchLoadingView: SearchLoadingView = {
        let searchLoadingView = SearchLoadingView()
        searchLoadingView.isHidden = true
        searchLoadingView.isUserInteractionEnabled = true
        return searchLoadingView
    }()
    
    private lazy var searchBar: SearchBar = {
        let screenWidth = UIApplication.shared.width
        let searchBar = SearchBar(frame: CGRect(x: 16, y: 0, width: screenWidth - 32, height: 44))
        let addtionTypeString = viewModel.userType == .parent ? UserType.child.string : UserType.parent.string
        searchBar.placeholder = addtionTypeString + " 추가"
        return searchBar
    }()
    
    private let tabContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews()
        tabViews.tabTitles = ["연동 목록", "받은 목록", "보낸 목록"]
        tabViews.initTabViews()
        tabViews.setTouchInteractionEnabled(true)
        return tabViews
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.register(LinkListTabCell.self, forCellReuseIdentifier: LinkListTabCell.reuseIdentifier)
        tableView.register(ReceivedTabCell.self, forCellReuseIdentifier: ReceivedTabCell.reuseIdentifier)
        tableView.register(SentTabCell.self, forCellReuseIdentifier: SentTabCell.reuseIdentifier)
        
        tableView.rowHeight = 54
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        
        return tableView
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
        setupNavigationBar()
        setupDelegate()
        setupAction()
        bindViewModel()
    }
}

extension LinkManagementViewController {
    private func setupUI() {
        view.backgroundColor = .white
        
        [searchBar, tabContentView, searchEmptyView, searchLoadingView, searchResultView, fullLoadingView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        tabContentView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(19)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        [tabViews, tableView].forEach {
            tabContentView.addSubview($0)
        }
        
        tabViews.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(28)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(tabViews.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        searchEmptyView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchLoadingView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        searchResultView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        fullLoadingView.snp.makeConstraints {
            $0.top.equalTo(tabViews.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setupNavigationBar() {
        setNavigationBarStyle()
        
        var configuration = UIButton.Configuration.plain()
        let backButtonImage = UIImage(systemName: "chevron.backward")?.withAlignmentRectInsets(Constants.backButtonPadding)
        configuration.image = backButtonImage
        
        let backButton = UIButton(configuration: configuration, primaryAction: UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: false)
        }))
        backButton.tintColor = .black
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        title = "연동 관리"
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                .font: UIFont.subtitle18Sbd
            ]
        }
    }
    
    private func setupDelegate() {
        tabViews.delegate = self
        searchBar.delegate = self
        searchResultView.delegate = self
    }
    
    private func setupAction() {
        searchLoadingView.cancelButton.addTarget(self, action: #selector(searchCancel), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        viewModel.$isTabLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.handleLoadingView(for: bool)
            }
            .store(in: &cancellables)
        
        viewModel.$linkTabState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.viewModel.handleTabState(for: state)
            }
            .store(in: &cancellables)
        
        viewModel.$dataList
            .map { array -> Bool in
                return array.isEmpty
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.tableView.reloadData()
                self?.handleEmptyView(for: bool)
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
        
        viewModel.$searchState
            .receive(on: DispatchQueue.main)
            .scan((previous: nil as SearchState?, current: viewModel.searchState)) { last, new in
                return (last.current, new)
            }
            .sink { [weak self] previousState, currentState in
                guard let self = self else { return }
                self.handleSearchState(for: currentState)
                if previousState != .inactive && currentState == .inactive  {
                    self.viewModel.handleTabState(for: self.viewModel.linkTabState)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$searchResultState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.searchResultView.handleSearchResult(for: state)
            }
            .store(in: &cancellables)
        
        viewModel.toastAppearSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] type in
                self?.toast = Toast(type: type)
                self?.toast?.show()
            }
            .store(in: &cancellables)
        
        viewModel.newAlertSubject
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newAlerts in
                self?.handleNewAlert(for: newAlerts)
            }
            .store(in: &cancellables)
    }
    
    private func handleLoadingView(for bool: Bool) {
        if true == bool {
            fullLoadingView.startLoading()
            tabViews.setTouchInteractionEnabled(!bool)
            searchBar.isUserInteractionEnabled = !bool
        } else {
            fullLoadingView.stopLoading()
            tabViews.setTouchInteractionEnabled(!bool)
            searchBar.isUserInteractionEnabled = !bool
        }
    }
    
    private func handleEmptyView(for bool: Bool) {
        tableEmptyView.isHidden = !bool
        
        if true == bool {
            switch viewModel.linkTabState {
            case .linkListTab:
                tableEmptyView.label.text = "연동된 " + (viewModel.userType == .child ? "아이" : "보호자") + "가 없어요"
            case .receivedTab:
                tableEmptyView.label.text = "받은 요청이 없어요"
            case .sentTab:
                tableEmptyView.label.text = "보낸 요청이 없어요"
            }
            
            tableView.backgroundView = tableEmptyView
        }
    }
    
    private func handleSearchState(for state: SearchState) {
        switch state {
        case .inactive:
            searchEmptyView.isHidden = true
            tableView.isHidden = false
            searchLoadingView.isHidden = true
            searchResultView.isHidden = true
            searchLoadingView.isHidden = true
            searchResultView.isHidden = true
        case .activated:
            searchEmptyView.isHidden = false
            tableView.isHidden = true
            searchLoadingView.isHidden = true
            searchResultView.isHidden = true
        case .searching(_):
            searchEmptyView.isHidden = true
            tableView.isHidden = true
            searchLoadingView.isHidden = false
            searchResultView.isHidden = true
        case .completed:
            searchEmptyView.isHidden = true
            tableView.isHidden = true
            searchLoadingView.isHidden = true
            searchResultView.isHidden = false
            searchBar.isCancelState.toggle()
            searchBar.activate(bool: true, keyboard: false)
        }
    }
    
    private func handleNewAlert(for newAlerts: CheckLinkRequest) {
        let receivedState = newAlerts.isFamilyReceived
        tabViews.updateNewAlert(index: 1, state: receivedState)
        let sentState = newAlerts.isFamilySent
        tabViews.updateNewAlert(index: 2, state: sentState)
    }
}

extension LinkManagementViewController: TabViewsDelegate {
    func tabViews(_ tabViews: TabViews, didSelectTabAtIndex index: Int) {
        switch index {
        case 0:
            viewModel.linkListTabTapped()
        case 1:
            viewModel.receivedTabTapped()
        case 2:
            viewModel.sentTabTapped()
        default:
            break
        }
    }
}

extension LinkManagementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard false == viewModel.dataList.isEmpty else {
            return UITableViewCell()
        }
        
        let family = viewModel.dataList[indexPath.row]
        switch viewModel.linkTabState {
        case .linkListTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: LinkListTabCell.reuseIdentifier, for: indexPath) as! LinkListTabCell
            cell.delegate = self
            cell.configure(family: family)
            return cell
        case .receivedTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedTabCell.reuseIdentifier, for: indexPath) as! ReceivedTabCell
            cell.delegate = self
            cell.configure(family: family)
            return cell
        case .sentTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: SentTabCell.reuseIdentifier, for: indexPath) as! SentTabCell
            cell.delegate = self
            cell.configure(family: family)
            return cell
        }
    }
    
    @objc func searchCancel(keyboard: Bool = true) {
        viewModel.cancelSearchRequest()
        searchBar.isCancelState.toggle()
        searchBar.activate(bool: true, keyboard: keyboard)
    }
}

// MARK: - LinkListTabCellDelegate
extension LinkManagementViewController: LinkListTabCellDelegate {
    func didTapClose(on cell: LinkListTabCell) {
        guard let nickName = cell.titleLabel.text else { return }
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else { return }
        
        let confirmAlert = LinkRequestAlertView()
        confirmAlert.titleLabel.text = "\(nickName)님과\n연동을 해제하시겠어요?"
        let emphasisRange = [NSRange(location: 0, length: nickName.count)]
        confirmAlert.titleLabel.setEmphasisRanges(emphasisRange, color: .gray700, font: .body18Bd)
        confirmAlert.confirmButton.text = "네, 해제할래요"
        confirmAlert.secondButtonAction = { [weak self] in
            guard let self = self else { return }
            Task {
                let memberID = self.viewModel.dataList[indexPathRow].memberID
                await self.viewModel.unlinkRequestDidTap(for: memberID)
                confirmAlert.dismiss(animated: false, completion: nil)
                self.tableView.reloadData()
            }
        }
        present(confirmAlert, animated: false)
    }
}

//MARK: - ReceivedTabCellDelegate
extension LinkManagementViewController: ReceivedTabCellDelegate {
    func didTapAccept(on cell: ReceivedTabCell) {
        guard let nickName = cell.titleLabel.text else { return }
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else { return }
        
        let confirmAlert = LinkRequestAlertView()
        confirmAlert.titleLabel.text = "\(nickName)님의\n연동 요청을 수락하시겠어요?"
        let emphasisRange = [NSRange(location: 0, length: nickName.count)]
        confirmAlert.titleLabel.setEmphasisRanges(emphasisRange, color: .gray700, font: .body18Bd)
        confirmAlert.confirmButton.text = "네, 좋아요!"
        confirmAlert.secondButtonAction = { [weak self] in
            guard let self = self else { return }
            Task {
                let memberID = self.viewModel.dataList[indexPathRow].memberID
                await self.viewModel.linkApproveDidTap(for: memberID)
                await self.viewModel.checkNewLinkRequest()
                confirmAlert.dismiss(animated: false, completion: nil)
                self.tableView.reloadData()
            }
        }
        present(confirmAlert, animated: false)
    }
    
    func didTapReject(on cell: ReceivedTabCell) {
        guard let nickName = cell.titleLabel.text else { return }
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else { return }
        
        let confirmAlert = LinkRequestAlertView()
        confirmAlert.titleLabel.text = "\(nickName)님의\n연동 요청을 거절하시겠어요?"
        let emphasisRange = [NSRange(location: 0, length: nickName.count)]
        confirmAlert.titleLabel.setEmphasisRanges(emphasisRange, color: .gray700, font: .body18Bd)
        confirmAlert.confirmButton.text = "네, 거절할래요"
        confirmAlert.secondButtonAction = { [weak self] in
            guard let self = self else { return }
            Task {
                let memberID = self.viewModel.dataList[indexPathRow].memberID
                await self.viewModel.linkRejectDidTap(for: memberID)
                await self.viewModel.checkNewLinkRequest()
                confirmAlert.dismiss(animated: false, completion: nil)
                self.tableView.reloadData()
            }
        }
        present(confirmAlert, animated: false)
    }
}

//MARK: - SentTabCellDelegate
extension LinkManagementViewController: SentTabCellDelegate {
    func didTapCancel(on cell: SentTabCell) {
        let confirmAlert = LinkRequestAlertView()
        guard let indexPathRow = tableView.indexPath(for: cell)?.row else { return }
        
        let nickname = viewModel.dataList[indexPathRow].nickname
        confirmAlert.titleLabel.text = "\(nickname)님에게 보낸\n연동 요청을 취소하시겠어요?"
        let emphasisRange = [NSRange(location: 0, length: nickname.count)]
        confirmAlert.titleLabel.setEmphasisRanges(emphasisRange, color: .gray700, font: .body18Bd)
        confirmAlert.confirmButton.text = "네, 취소할래요"
        confirmAlert.secondButtonAction = { [weak self] in
            guard let self = self else { return }
            Task {
                let memberID = self.viewModel.dataList[indexPathRow].memberID
                await self.viewModel.linkCancelDidTap(for: memberID)
                await self.viewModel.checkNewLinkRequest()
                confirmAlert.dismiss(animated: false, completion: nil)
                self.tableView.reloadData()
            }
        }
        
        navigationController?.present(confirmAlert, animated: false)
    }
}

//MARK: - SearchBarDelegate
extension LinkManagementViewController: SearchBarDelegate {
    func searchBarDidBeginEditing(_ searchBar: SearchBar) {
        if searchBar.searchBarSubView.searchBarTextField.text == "" {
            viewModel.searchState = .activated
        }
    }
    
    func searchBarDidEndEditing(_ searchBar: SearchBar) {
        switch viewModel.searchState {
        case .searching(_):
            searchEmptyView.isHidden = false
            tableView.isHidden = true
            searchLoadingView.isHidden = true
        default:
            viewModel.searchState = .inactive
        }
    }
    
    func search(_ searchBar: SearchBar, searchText: String) {
        searchLoadingView.configure(nickName: searchText)
        Task {
            await viewModel.searchUserByNickname(searchText)
        }
    }
}

//MARK: - SearchResultViewDelegate
extension LinkManagementViewController: SearchResultViewDelegate {
    func linkRequest(nickName: String, memberID: Int) {
        if let familyStatus = searchResultView.familyMember?.familyStatus, familyStatus == .received {
            viewModel.toastAppearSubject.send(.error("이미 해당 회원에게 연동 요청을 받았어요"))
        } else {
            let confirmAlert = LinkRequestAlertView()
            confirmAlert.titleLabel.text = "\(nickName)님에게\n연동 요청을 보낼까요?"
            let emphasisRange = [NSRange(location: 0, length: nickName.count)]
            confirmAlert.titleLabel.setEmphasisRanges(emphasisRange, color: .gray700, font: .body18Bd)
            confirmAlert.confirmButton.text = "네, 좋아요!"
            confirmAlert.secondButtonAction = { [weak self] in
                guard let self = self else { return }
                Task {
                    await self.viewModel.linkRequestDidTap(for: memberID)
                    confirmAlert.dismiss(animated: false, completion: nil)
                    self.tableView.reloadData()
                }
            }
            
            present(confirmAlert, animated: false)
        }
    }
    
    @MainActor func linkRequestCancel(memberID: Int) {
        Task {
            viewModel.showLoading()
            await viewModel.linkCancelDidTap(for: memberID)
            viewModel.hideLoading()
            searchResultView.requestCancel()
            viewModel.toastAppearSubject.send(.success("요청이 취소됐어요"))
        }
    }
}
