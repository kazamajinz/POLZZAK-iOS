//
//  NotificationSettingViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/13.
//

import UIKit
import SnapKit

final class NotificationSettingViewController: UIViewController {
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "모든알림", textColor: .gray800, font: .subtitle16Sbd)
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.setLabel(textColor: .gray500, font: .caption12Md)
        return label
    }()
    
    let allSettingSwitch: UISwitch = {
        let customSwitfch = UISwitch()
        customSwitfch.onTintColor = .blue500
        customSwitfch.addTarget(NotificationSettingViewController.self, action: #selector(openAppSettings), for: .valueChanged)
        return customSwitfch
    }()
    
    let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = .gray300
        return view
    }()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationSettingTableViewCell.self, forCellReuseIdentifier: NotificationSettingTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    var dataSource = [["연동알림", "연동 요청이 들어오거나 연동에 성공한 경우 알림을 받을래요"],
                      ["레벨알림", "레벨 변동에 대한 알림을 받을래요"],
                      ["도장요청 알림", "아이의 도장 요청 알림을 받을래요"],
                      ["선물 조르기 알림", "아이의 선물 조르기 알림을 받을래요"],
                      ["도장판 완성 알림", "도장판이 모두 채워졌다는 알림을 받을래요"],
                      ["선물 수령 알림", "아이가 선물을 받았다고 보내는 감사 인사를 받을래요"],
                      ["선물 약속 미이행 알림", "선물 약속 날짜를 어겼다는 알림을 받을래요"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigation()
        setTbleView()
        addBecameActiveObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkNotificationAuthorizationStatus()
    }
}

extension NotificationSettingViewController {
    private func setUI() {
        view.backgroundColor = .gray100
        
        [headerView, bottomLine, tableView].forEach {
            view.addSubview($0)
        }
        
        [titleLabel, allSettingSwitch].forEach {
            headerView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.height.equalTo(allSettingSwitch.snp.height)
        }
        
        allSettingSwitch.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing)
        }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        bottomLine.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(bottomLine.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setNavigation() {
        title = "알림 설정"
    }
    
    private func setTbleView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .gray100
    }
    
    private func addBecameActiveObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(appBecameActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func notificationSwitchTapped(_ mySwitch: UISwitch) {
        if let appSettingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    @objc func allSettingSwitchValueChanged(sender: UISwitch) {
        checkNotificationAuthorizationStatus()
    }
    
    @objc func appBecameActive() {
        checkNotificationAuthorizationStatus()
    }
    
    
    //    //TODO: - 서버 API통신을 연결할예정, 바인딩도 필요.
    //    @objc func switchChanged(_ mySwitch: UISwitch) {
    //        let row = mySwitch.tag
    //        if testBoolData.filter({true == $0}).count == 1 {
    //            mySwitch.isOn = !mySwitch.isOn
    //        } else {
    //            checkNotificationAuthorizationStatus()
    //        }
    //    }
    
    @objc func openAppSettings(sender: UISwitch) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Opened settings: \(success)")
            })
        }
    }
    
    private func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let firstIndexPath = IndexPath(row: 0, section: 0)
                if self.tableView.cellForRow(at: firstIndexPath) is NotificationSettingTableViewCell {
                    switch settings.authorizationStatus {
                    case .authorized, .provisional:
                        self.allSettingSwitch.isOn = true
                        print(".authorized, .provisional")
                    case .denied:
                        self.allSettingSwitch.isOn = false
                        print(".denied")
                    default:
                        return
                    }
                }
            }
        }
    }
}

extension NotificationSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingTableViewCell.reuseIdentifier, for: indexPath) as! NotificationSettingTableViewCell
        let titleText = dataSource[indexPath.row][0]
        let detailText = dataSource[indexPath.row][1]
        cell.customSwitch.tag = indexPath.row
        cell.configure(titleText: titleText, detailText: detailText, isSwitchOn: false)
        
        if indexPath.row == 6 {
            cell.hideBottomLine()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52 + 32
    }
}
