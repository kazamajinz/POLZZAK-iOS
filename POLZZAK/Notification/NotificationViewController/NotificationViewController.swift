//
//  NotificationViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/11.
//

import UIKit
import SnapKit
import Combine
//import CombineCocoa

final class NotificationViewController: UIViewController {
    private let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NotificationTableViewCell.self, forCellReuseIdentifier: NotificationTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: -16, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .gray100
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var dummyData = NotificationDummyDataGenerator.generateDummyData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigation()
        setTableView()
    }
}

extension NotificationViewController {
    private func setUI() {
        view.backgroundColor = .white
        
        view.addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentsView.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setNavigation() {
        title = "알림"
        
        navigationController?.navigationBar.tintColor = .gray800
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        let rightButtonImage = UIImage.notificationSettingButton
        let rightButton = UIBarButtonItem(image: rightButtonImage, style: .plain, target: self, action: #selector(notificationSetting))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc private func notificationSetting() {
        let notificationSettingViewController = NotificationSettingViewController()
        notificationSettingViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(notificationSettingViewController, animated: true)
    }
    
    private func setTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension NotificationViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dummyData.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTableViewCell.reuseIdentifier, for: indexPath) as! NotificationTableViewCell
        cell.delegate = self
        cell.configure(data: dummyData[indexPath.section])
        return cell
    }
}

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension NotificationViewController: NotificationTableViewCellDelegate {
    func didTapAcceptButton(_ cell: NotificationTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        print("수락", indexPath.section)
    }

    func didTapRejectButton(_ cell: NotificationTableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        print("거절", indexPath.section)
    }
}
