//
//  NotificationSettingViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/13.
//

import UIKit
import SnapKit

final class NotificationSettingViewController: UIViewController {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NotificationSettingTableViewCell.self, forCellReuseIdentifier: NotificationSettingTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .gray100
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
    
    var deviceNotification: Bool = true
    var testBoolData = (0...6).map{ _ in [true, false].randomElement()! }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setNavigation()
        setTbleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkNotificationAuthorizationStatus()
    }
}

extension NotificationSettingViewController {
    private func setUI() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setNavigation() {
        title = "알림 설정"
    }
    
    private func setTbleView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func notificationSwitchTapped(_ mySwitch: CustomSwitch) {
        if let appSettingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    //TODO: - 서버 API통신을 연결할예정, binding도 필요.
        @objc func switchChanged(_ mySwitch: CustomSwitch) {
            let row = mySwitch.tag
            if testBoolData.filter({true == $0}).count == 1 {
                mySwitch.isSwitchOn = !mySwitch.isSwitchOn
            } else {
                testBoolData[row] = mySwitch.isSwitchOn
                checkNotificationAuthorizationStatus()
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
                        self.deviceNotification = true
//                        if false == cell.customSwitch.isOn {
//                            cell.customSwitch.isOn = true
//                            self?.testBoolData = [Bool](repeating: true, count: 7)
//                        }
//                        for (index, isOn) in self.testBoolData.enumerated() {
//                            if !isOn {
//                                self.testBoolData[index] = true
//                            }
//                        }
                    case .denied:
                        self.deviceNotification = false
//                        if true == cell.customSwitch.isOn {
//                            cell.customSwitch.isOn = false
//                            self.testBoolData = [Bool](repeating: false, count: 7)
//                        }
//                        for (index, isOn) in self.testBoolData.enumerated() {
//                            if isOn {
//                                self.testBoolData[index] = false
//                            }
//                        }
                    default:
                        return
                    }
                }
            }
        }
    }
}

extension NotificationSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSettingTableViewCell.reuseIdentifier, for: indexPath) as! NotificationSettingTableViewCell
        if indexPath.section != 0 {
            let titleText = dataSource[indexPath.row][0]
            let detailText = dataSource[indexPath.row][1]
            let isSwitchOn = testBoolData[indexPath.row]
            cell.customSwitch.tag = indexPath.row
            cell.configure(titleText: titleText, detailText: detailText, isSwitchOn: isSwitchOn)
            cell.customSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        } else {
            cell.customSwitch.isSwitchOn = testBoolData.contains(true)
            cell.customSwitch.addTarget(self, action: #selector(notificationSwitchTapped), for: .valueChanged)
            cell.customSwitch.isSwitchOn = testBoolData.contains(true)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            
            let lineView = UIView()
            lineView.backgroundColor = .gray300
            
            footerView.addSubview(lineView)
            
            lineView.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(16)
                make.trailing.equalToSuperview().inset(16)
                make.bottom.equalToSuperview()
                make.height.equalTo(1)
            }
            
            return footerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 25
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 24 + 24
        } else {
            return 45 + 32
        }
    }
}
