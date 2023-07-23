//
//  LinkManagementViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/09.
//

import UIKit
import SnapKit

//TODO: - 임시
enum LinkTabStyle {
    case linkListTab
    case receivedTab
    case sentTab
}

final class LinkManagementViewController: UIViewController {
    
    //MARK: - let, var
    var userType: UserType
    let screenWidth = UIApplication.shared.width
    private var workItem: DispatchWorkItem?
    
    //TODO: - 임시코드, 새로운 API통신을 했다는 가정
    private var linkManagementTabState: LinkTabStyle = .linkListTab {
        didSet {
            
            if 0 == testData.count {
                return
            }
            //TODO: - 새로운 API통신을 했다는 가정
            fullScreenLoadingView.startLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self = self else { return }
                switch linkManagementTabState {
                case .linkListTab:
                    tableEmptyView.label.setLabel(text: "연동된 아이가 없어요", textColor: .gray700, font: .body3, textAlignment: .center)
                case .receivedTab:
                    tableEmptyView.label.setLabel(text: "받은 요청이 없어요", textColor: .gray700, font: .body3, textAlignment: .center)
                case .sentTab:
                    tableEmptyView.label.setLabel(text: "보낸 요청이 없어요", textColor: .gray700, font: .body3, textAlignment: .center)
                }

                tableView.backgroundView = tableEmptyView
                tableView.reloadData()

                self.fullScreenLoadingView.stopLoading()
            }
        }
    }
    
    //TODO: - 임시데이터
    private var testData: [FamilyMember] = dummyFmailyData.families {
        didSet {
            if testData.isEmpty {
                tableEmptyView.showBackgroundView()
            } else {
                tableEmptyView.hideBackgroundView()
            }
            tableView.reloadData()
        }
    }
    
    private var searchState: SearchState = .beforeSearch(isSearchBarActive: false) {
        didSet {
            switch searchState {
            case .beforeSearch(isSearchBarActive: let isSearchBarActive):
                if false == isSearchBarActive {
                    searchEmptyView.isHidden = true
                    tableView.isHidden = false
                    searchLoadingView.isHidden = true
                    searchResultView.isHidden = true
                } else {
                    searchEmptyView.isHidden = false
                    tableView.isHidden = true
                    searchLoadingView.isHidden = true
                    searchResultView.isHidden = true
                }
            case .searching(let text):
                searchEmptyView.isHidden = true
                tableView.isHidden = true
                searchLoadingView.isHidden = false
                searchResultView.isHidden = true
                searching(text: text ?? "")
            case .afterSearch:
                searchEmptyView.isHidden = true
                tableView.isHidden = true
                searchLoadingView.isHidden = true
                searchResultView.isHidden = false
            }
        }
    }
    
    private var searchResultState: SearchResultState = .notSearch {
        didSet {
            switch searchResultState {
            case .linked(let familyMember):
                let type = SearchResultState.linked(familyMember)
                searchResultView.setType(type: type)
            case .unlinked(let familyMember):
                let type = SearchResultState.unlinked(familyMember)
                searchResultView.setType(type: type)
            case .linkedRequestComplete(let familyMember):
                let type = SearchResultState.linkedRequestComplete(familyMember)
                searchResultView.setType(type: type)
            case .nonExist(let nickname):
                let type = SearchResultState.nonExist(nickname)
                searchResultView.setType(type: type)
            case .notSearch:
                return
            }
            searchCancel(keyboard: false)
        }
    }
    
    //MARK: - UI
    private var tableEmptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.label.setLabel(text: "연동된 아이가 없어요", textColor: .gray700, font: .body3, textAlignment: .center)
        emptyView.imageView.image = .sittingCharacter
        return emptyView
    }()
    
    private lazy var searchEmptyView: EmptyView = {
        let emptyView = EmptyView()
        emptyView.topSpacing = 229
        emptyView.label.setLabel(text: "연동된 \(userType.string)에게\n칭안 도장판을 만들어 줄 수 있어요", textColor: .gray500, font: .caption2, textAlignment: .center)
        emptyView.imageView.image = .searchImage
        emptyView.isHidden = true
        return emptyView
    }()
    private var searchResultView: SearchResultView = SearchResultView()
    private let fullScreenLoadingView = FullScreenLoadingView()
    
    private let searchLoadingView: SearchLoadingView = {
        let searchLoadingView = SearchLoadingView()
        searchLoadingView.isHidden = true
        searchLoadingView.isUserInteractionEnabled = true
        return searchLoadingView
    }()
    
    private lazy var searchBar: SearchBar = {
        let screenWidth = UIApplication.shared.width
        let searchBar = SearchBar(frame: CGRect(x: 16, y: 0, width: screenWidth - 32, height: 44))
        searchBar.placeholder = userType.string
        return searchBar
    }()
    
    private let tabContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews()
        tabViews.tabTitles = ["연동 목록", "받은 목록", "보낸 목록"]
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
    
    init(userType: UserType) {
        self.userType = userType
        super.init(nibName: nil, bundle: nil)
        
        setNavigation()
        setUI()
        setDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: - API통신
        linkManagementTabState = .linkListTab
        setAction()
    }
}

extension LinkManagementViewController {
    private func setNavigation() {
        title = "연동 관리"
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                .font: UIFont.subtitle1
            ]
        }
    }
    
    private func setUI() {
        view.backgroundColor = .white
        
        [searchBar, tabContentView, searchEmptyView, searchLoadingView, searchResultView, fullScreenLoadingView].forEach {
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
        
        fullScreenLoadingView.snp.makeConstraints {
            $0.top.equalTo(tabViews.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func setDelegate() {
        tabViews.delegate = self
        searchBar.delegate = self
        searchResultView.delegate = self
    }
    
    private func setAction() {
        searchLoadingView.cancelButton.addTarget(self, action: #selector(searchCancel), for: .touchUpInside)
    }
    
    private func linkListTabTapped() {
        //TODO: - 새로운 API통신을 했다는 가정
//        beforeState = linkManagementTabState
        
        linkManagementTabState = .linkListTab
    }
    
    private func receivedTabTapped() {
        //TODO: - 새로운 API통신을 했다는 가정
//        beforeState = linkManagementTabState
        
        linkManagementTabState = .receivedTab
    }
    
    private func sentTabTapped() {
        //TODO: - 새로운 API통신을 했다는 가정
//        beforeState = linkManagementTabState
        
        linkManagementTabState = .sentTab
    }
}

extension LinkManagementViewController: TabViewsDelegate {
    func tabViews(_ tabViews: TabViews, didSelectTabAtIndex index: Int) {
        switch index {
        case 0:
            linkListTabTapped()
        case 1:
            receivedTabTapped()
        case 2:
            sentTabTapped()
        default:
            break
        }
    }
}

extension LinkManagementViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let family = testData[indexPath.row]
        switch linkManagementTabState {
        case .linkListTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: LinkListTabCell.reuseIdentifier, for: indexPath) as! LinkListTabCell
            cell.delegate = self
            cell.configure(with: family)
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
    
    //    TODO: - API통신 취소 기능 추가
    @objc func searchCancel(keyboard: Bool = true) {
        workItem?.cancel()
        //TODO: - 커밋전에 체크
        if searchState == .searching() {
            searchState = .beforeSearch(isSearchBarActive: true)
        }
        searchBar.isCancelState.toggle()
        searchBar.activate(bool: true, keyboard: keyboard)
    }
    
    // TODO: - 임시 삭제 API 함수
    func tempRemove(memberId: Int = -1, completion: (() -> Void)? = nil) {
        if memberId == -1 {
            testData = dummyFmailyData.families
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.testData.remove(at: memberId)
                completion?()
            }
        }
    }
    
    //TODO: - 임시 연동요청 API 함수
    func tempLinkRequest(memberId: Int = -1, completion: @escaping () -> Void) {
        if memberId == -1 {
            testData = dummyFmailyData.families
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                completion()
            }
        }
    }
    
    //TODO: - 임시 요청취소 API 함수
    @objc private func requestCancel(memberId: Int = -1, completion: @escaping () -> Void) {
        if memberId == -1 {
            testData = dummyFmailyData.families
        } else {
            fullScreenLoadingView.startLoading()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.fullScreenLoadingView.stopLoading()
                completion()
            }
        }
    }
    
    //TODO: - 임시데이터를 포함한 검색로직
    private func searching(text: String) {
        workItem?.cancel()
        
        workItem = DispatchWorkItem { [weak self] in
            self?.searchState = .afterSearch
            if text == "연동" {
                let tempFamilyMember = tempDummyData.first!.familyMember
                self?.searchResultState = .linked(tempFamilyMember)
            } else if text == "미연동" {
                let tempFamilyMember = tempDummyData.first!.familyMember
                self?.searchResultState = .unlinked(tempFamilyMember)
            } else {
                self?.searchResultState = .nonExist(text)
            }
        }
        
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: workItem)
        }
    }
}

// MARK: - LinkListTabCellDelegate
extension LinkManagementViewController: LinkListTabCellDelegate {
    func didTapClose(on cell: LinkListTabCell) {
        if let nickName = cell.titleLabel.text, let indexPath = tableView.indexPath(for: cell)?.row {
            let alert = CustomAlertViewController()
            let emphasisRangeArray = [NSRange(location: 0, length: nickName.count)]
            let builder = LabelStyleBuilder()
            let style = builder.setText("\(nickName)님과\n연동을 해제하시겠어요?")
                .setTextColor(.gray700)
                .setFont(.body7)
                .setTextAlignment(.center)
                .setEmphasisRangeArray(emphasisRangeArray)
                .setEmphasisColor(.gray700)
                .setEmphasisFont(.body6)
                .build()
            alert.contentLabel.setLabel(style: style)
            alert.secondButton.setTitle("네, 해제할래요", for: .normal)
            alert.isLoadingView = true
            
            alert.secondButtonAction = { [weak self] in
                self?.tempRemove(memberId: indexPath)
            }
            
            present(alert, animated: false)
        }
    }
}

//MARK: - ReceivedTabCellDelegate
extension LinkManagementViewController: ReceivedTabCellDelegate {
    func didTapAccept(on cell: ReceivedTabCell) {
        if let nickName = cell.titleLabel.text, let indexPath = tableView.indexPath(for: cell)?.row {
            let alert = CustomAlertViewController()
            let emphasisRangeArray = [NSRange(location: 0, length: nickName.count)]
            let builder = LabelStyleBuilder()
            let style = builder.setText("\(nickName)님의\n연동 요청을 수락하시겠어요?")
                .setTextColor(.gray700)
                .setFont(.body7)
                .setTextAlignment(.center)
                .setEmphasisRangeArray(emphasisRangeArray)
                .setEmphasisColor(.gray700)
                .setEmphasisFont(.body6)
                .build()
            alert.contentLabel.setLabel(style: style)
            alert.secondButton.setTitle("네, 좋아요!", for: .normal)
            alert.isLoadingView = true
            
            alert.secondButtonAction = { [weak self] in
                self?.tempRemove(memberId: indexPath)
            }
            
            present(alert, animated: false)
        }
    }
    
    func didTapReject(on cell: ReceivedTabCell) {
        if let nickName = cell.titleLabel.text, let indexPath = tableView.indexPath(for: cell)?.row {
            let alert = CustomAlertViewController()
            let emphasisRangeArray = [NSRange(location: 0, length: nickName.count)]
            let builder = LabelStyleBuilder()
            let style = builder.setText("\(nickName)님의\n연동 요청을 거절하시겠어요?")
                .setTextColor(.gray700)
                .setFont(.body7)
                .setTextAlignment(.center)
                .setEmphasisRangeArray(emphasisRangeArray)
                .setEmphasisColor(.gray700)
                .setEmphasisFont(.body6)
                .build()
            alert.contentLabel.setLabel(style: style)
            alert.secondButton.setTitle("네, 거절할래요", for: .normal)
            
            alert.secondButtonAction = { [weak self] in
                self?.tempRemove(memberId: indexPath)
            }
            
            present(alert, animated: false)
        }
    }
}

//MARK: - SentTabCellDelegate
extension LinkManagementViewController: SentTabCellDelegate {
    func didTapCancel(on cell: SentTabCell) {
        if let nickName = cell.titleLabel.text, let indexPath = tableView.indexPath(for: cell)?.row {
            let alert = CustomAlertViewController()
            let emphasisRangeArray = [NSRange(location: 0, length: nickName.count)]
            let builder = LabelStyleBuilder()
            let style = builder.setText("\(nickName)님에게 보낸\n연동 요청을 취소하시겠어요?")
                .setTextColor(.gray700)
                .setFont(.body7)
                .setTextAlignment(.center)
                .setEmphasisRangeArray(emphasisRangeArray)
                .setEmphasisColor(.gray700)
                .setEmphasisFont(.body6)
                .build()
            alert.contentLabel.setLabel(style: style)
            alert.secondButton.setTitle("네, 취소할래요", for: .normal)
            alert.isLoadingView = true
            
            alert.secondButtonAction = { [weak self] in
                self?.tempRemove(memberId: indexPath)
            }
            
            present(alert, animated: false)
        }
    }
}

//MARK: - SearchBarDelegate
extension LinkManagementViewController: SearchBarDelegate {
    func searchBarDidBeginEditing(_ searchBar: SearchBar) {
        print("searchBarDidBeginEditing")
        if searchBar.searchBarSubView.searchBarTextField.text == "" {
            print("searchBarDidBeginEditing_searchBarTextField.text.isEmpty")
            searchState = .beforeSearch(isSearchBarActive: true)
        }
    }
    
    func searchBarDidEndEditing(_ searchBar: SearchBar) {
        print("searchBarDidEndEditing")
        if searchState == .searching() {
            searchEmptyView.isHidden = false
            tableView.isHidden = true
            searchLoadingView.isHidden = true
        } else {
            searchState = .beforeSearch(isSearchBarActive: false)
        }
    }
    
    func search(_ searchBar: SearchBar, searchText: String) {
        searchLoadingView.configure(nickName: searchText)
        searchState = .searching(nickName: searchText)
    }
}

//MARK: - SearchResultViewDelegate
extension LinkManagementViewController: SearchResultViewDelegate {
    func linkRequest(nickName: String, memberId: Int) {
        let alert = CustomAlertViewController()
        let emphasisRangeArray = [NSRange(location: 0, length: nickName.count)]
        let builder = LabelStyleBuilder()
        let style = builder.setText("\(nickName)님에게\n연동 오쳥을 보낼까요?")
            .setTextColor(.gray700)
            .setFont(.body7)
            .setTextAlignment(.center)
            .setEmphasisRangeArray(emphasisRangeArray)
            .setEmphasisColor(.gray700)
            .setEmphasisFont(.body6)
            .build()
        alert.contentLabel.setLabel(style: style)
        alert.secondButton.setTitle("네, 좋아요!", for: .normal)
        alert.isLoadingView = true
        
        //TODO: - API연결하고 수정필요, requestCompletion을 통해서 연동취소버튼을 노출/미노출, API연결이 안된상태에서 체크하기위해 하드코딩되어있음, 버그도있음.
        alert.secondButtonAction = { [weak self] in
            self?.tempLinkRequest(memberId: memberId) {
                self?.searchResultView.requestCompletion()
            }
        }
        
        present(alert, animated: false)
    }
    
    func linkRequestCancel(memberId: Int) {
        self.requestCancel(memberId: memberId) { [weak self] in
            guard let self = self else { return }
            let toast = Toast(text: "요청이 취소됐어요")
            toast.show(controller: self)
            //TODO: - API연결하고 수정필요, requestCancel을 통해서 연동취소버튼을 노출/미노출, API연결이 안된상태에서 체크하기위해 하드코딩되어있음, 버그도있음.
            self.searchResultView.requestCancel()
        }
    }
}
