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
    
    private var linkManagementTabState: LinkManagementTabState = .linkListTab {
        didSet {
            tableView.reloadData()
        }
    }
    
    //TODO: - 임시데이터
    let testData = dummyFmailyData.families
    
    //MARK: - UI

    private let searchBar: SearchBar = {
        let screenWidth = UIApplication.shared.width
        let searchBar = SearchBar(frame: CGRect(x: 16, y: 0, width: screenWidth - 32, height: 44), style: .linkManagement("아이"))
        return searchBar
    }()
    
    private let tabViews: TabViews = {
        let tabViews = TabViews(tabStyle: .linkManagement)
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
    
    private func linkListTabTapped() -> Void {
        linkManagementTabState = .linkListTab
    }
    
    private func receivedTabTapped() -> Void {
        linkManagementTabState = .receivedTab
    }
    
    private func sentTabTapped() -> Void {
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
            cell.configure(family: family)
            return cell
        case .receivedTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: ReceivedTabCell.reuseIdentifier) as! ReceivedTabCell
            cell.configure(family: family)
            return cell
        case .sentTab:
            let cell = tableView.dequeueReusableCell(withIdentifier: SentTabCell.reuseIdentifier) as! SentTabCell
            cell.configure(family: family)
            return cell
        }
    }
}
