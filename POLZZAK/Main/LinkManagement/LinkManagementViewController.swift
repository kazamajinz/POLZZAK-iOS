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
    
    private let linkListTab: SectionTabView = {
        let sectionTabView = SectionTabView(text: "연동목록", font: .subtitle2, lineHeight: 1)
        return sectionTabView
    }()
    
    private let receivedTab: SectionTabView = {
        let sectionTabView = SectionTabView(text: "받은 요청", font: .subtitle2, lineHeight: 1)
        return sectionTabView
    }()
    
    private let sentTab: SectionTabView = {
        let sectionTabView = SectionTabView(text: "보낸 요청", font: .subtitle2, lineHeight: 1)
        return sectionTabView
    }()
    
    private let headerTabStackView: UIStackView = {
        let screenWidth = UIApplication.shared.width
        let stackView = UIStackView(frame: CGRect(x: 16, y: 44, width: screenWidth - 32, height: 56))
        stackView.backgroundColor = .white
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        return tableView
    }()
    
    init(type: Int) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setNavigation()
        setUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        
        view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(44)
        }
        
    }
}
