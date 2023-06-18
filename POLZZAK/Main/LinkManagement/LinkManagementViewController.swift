//
//  LinkManagementViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/09.
//

import UIKit
import SnapKit

final class LinkManagementViewController: UIViewController {
    
    //MARK: - let, var
    var type: Int
    let screenWidth = UIApplication.shared.width
    
    //TODO: - 새로운 API통신을 했다는 가정
    private var beforeState: TabStyle = .receivedTab
    
    private var linkManagementTabState: TabStyle = .linkListTab {
        didSet {
            //TODO: - 새로운 API통신을 했다는 가정
            if beforeState != linkManagementTabState {
                testData = dummyFmailyData.families
            }
            
            testData = dummyFmailyData.families
            
            emptyView.setStyle(linkManagementTabState)
            tableView.backgroundView = emptyView
            tableView.reloadData()
        }
    }
    
    //TODO: - 임시데이터
    var testData: [FamilyMember] = dummyFmailyData.families {
        didSet {
            if testData.isEmpty {
                emptyView.showBackgroundView()
            } else {
                emptyView.hideBackgroundView()
            }
            tableView.reloadData()
        }
    }
    
    //MARK: - UI
    private var emptyView: EmptyView = EmptyView(style: .linkListTab)
    
    private let searchBar: SearchBar = {
        let screenWidth = UIApplication.shared.width
        let searchBar = SearchBar(frame: CGRect(x: 16, y: 0, width: screenWidth - 32, height: 44), style: .linkManagement("아이"))
        return searchBar
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews(tabStyle: .linkListTab)
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
    
    init(type: Int) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        
        setNavigation()
        setUI()
        setTabViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: - API통신
        linkManagementTabState = .linkListTab
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
        
        [searchBar, tabViews, tableView].forEach {
            view.addSubview($0)
        }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
        tabViews.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(13)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(38)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(tabViews.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setTabViews() {
        tabViews.delegate = self
    }
    
    private func linkListTabTapped() {
        //TODO: - 새로운 API통신을 했다는 가정
        beforeState = linkManagementTabState
        
        linkManagementTabState = .linkListTab
    }
    
    private func receivedTabTapped() {
        //TODO: - 새로운 API통신을 했다는 가정
        beforeState = linkManagementTabState
        
        linkManagementTabState = .receivedTab
    }
    
    private func sentTabTapped() {
        //TODO: - 새로운 API통신을 했다는 가정
        beforeState = linkManagementTabState
        
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
            let cell = tableView.dequeueReusableCell(withIdentifier: LinkListTabCell.reuseIdentifier) as! LinkListTabCell
            cell.delegate = self
            cell.configure(with: family)
            return cell
        case .receivedTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedTabCell.reuseIdentifier) as! ReceivedTabCell
            cell.delegate = self
            cell.configure(family: family)
            return cell
        case .sentTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: SentTabCell.reuseIdentifier) as! SentTabCell
            cell.delegate = self
            cell.configure(family: family)
            return cell
        }
    }
    
    func showAlert(alertStyle: AlertStyle, memberId: Int) {
        let action = { [weak self] (completion: @escaping () -> Void) in
            self?.testAPI(memberId: memberId) {
                completion()
            }
            return
        }
        
        let alertVC = CustomAlertViewController(alertStyle: alertStyle, action: action)
        alertVC.modalPresentationStyle = .overCurrentContext
        present(alertVC, animated: false)
    }
    
    // TODO: - 임시 API 함수
    func testAPI(memberId: Int = -1, completion: @escaping () -> Void) {
        if memberId == -1 {
            testData = dummyFmailyData.families
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                if let index = self?.testData.firstIndex(where: { $0.memberId == memberId }) {
                    self?.testData.remove(at: index)
                }
                completion()
            }
        }
    }
}

// MARK: - LinkListTabCellDelegate
extension LinkManagementViewController: LinkListTabCellDelegate {
    func didTapClose(on cell: LinkListTabCell) {
        if let family = cell.family {
            showAlert(alertStyle: UnlinkAlertStyle.unlink(family.nickname), memberId: family.memberId)
        }
    }
}

//MARK: - ReceivedTabCellDelegate
extension LinkManagementViewController: ReceivedTabCellDelegate {
    func didTapAccept(on cell: ReceivedTabCell) {
        if let family = cell.family {
            showAlert(alertStyle: UnlinkAlertStyle.receivedAccept(family.nickname), memberId: family.memberId)
        }
    }
    
    func didTapReject(on cell: ReceivedTabCell) {
        if let family = cell.family {
            showAlert(alertStyle: UnlinkAlertStyle.receivedReject(family.nickname), memberId: family.memberId)
        }
    }
}

//MARK: - SentTabCellDelegate
extension LinkManagementViewController: SentTabCellDelegate {
    func didTapCancel(on cell: SentTabCell) {
        if let family = cell.family {
            showAlert(alertStyle: UnlinkAlertStyle.requestCancel(family.nickname), memberId: family.memberId)
        }
    }
}
