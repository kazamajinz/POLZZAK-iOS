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
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init(type: Int) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        self.tabViews.delegate = self
        setNavigation()
        setUI()
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
        
        [searchBar, tabViews].forEach {
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
    }
    
    private func linkListTabTapped() -> Void {
        
    }
    
    private func receivedTabTapped() -> Void {
        
    }
    
    private func sentTabTapped() -> Void {
        
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
