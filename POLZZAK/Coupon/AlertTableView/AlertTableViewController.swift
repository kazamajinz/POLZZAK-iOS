//
//  AlertTableViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/21.
//

import UIKit
import SnapKit

final class AlertTableViewController: BaseAlertViewController {
    enum Constants {
        static let alertHeight = UIApplication.shared.height * 460.0 / 812.0
        static let cellHeight = 44.0
    }
    
    private var data: [String] = []
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "완료한 미션", textColor: .gray800, font: .subtitle16Sbd)
        return label
    }()
    
    private let titleCountLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .blue500, font: .subtitle16Sbd)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.register(AlertTableViewCell.self, forCellReuseIdentifier: AlertTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private let closeButton: PaddedLabel = {
        let closeButton = PaddedLabel(padding: UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24))
        closeButton.setLabel(text: "닫기", textColor: .white, font: .subtitle16Sbd, textAlignment: .center, backgroundColor: .blue500)
        closeButton.addCornerRadious(cornerRadius: 8)
        closeButton.isUserInteractionEnabled = true
        return closeButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        setupActions()
    }
}

extension AlertTableViewController {
    
    private func setupUI() {
        [titleLabel, titleCountLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [titleStackView, tableView, closeButton].forEach {
            contentView.addSubview($0)
        }
        
        contentView.snp.makeConstraints{
            $0.height.equalTo(Constants.alertHeight)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom).offset(12)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setupTableView() {
        tableView.separatorInset = .init(top: 14, left: 12, bottom: 14, right: 12)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupActions() {
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tabClose)))
    }
    
    func configure(data: [String]) {
        self.data = data
        titleCountLabel.text = "\(data.count)"
        tableView.reloadData()
    }
    
    @objc private func tabClose() {
        dismiss(animated: false)
    }
}

extension AlertTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AlertTableViewCell.reuseIdentifier, for: indexPath) as! AlertTableViewCell
        cell.contentLabel.setLabel(text: data[indexPath.row], textColor: .gray800, font: .body14Md)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
