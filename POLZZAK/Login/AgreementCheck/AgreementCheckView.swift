//
//  AgreementCheckView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/07/21.
//

import UIKit

class AgreementCheckView: UITableView {
    private let isAgreeAllRowHidden: Bool
    private let isRightArrowHidden: Bool
    private let leadingInset: CGFloat
    
    private var headerFont: UIFont = .body15Md
    private var cellFont: UIFont = .body15Md
    private var headerTextColor: UIColor = .gray800
    private var cellTextColor: UIColor = .gray500
    
    private var agreeAllTitle: String = "모두 동의"
    private var agreementList: [String] = [] {
        didSet {
            reloadData()
        }
    }
    
    init(frame: CGRect = .zero, isAgreeAllRowHidden: Bool = true, isRightArrowHidden: Bool = true, leadingInset: CGFloat = 0) {
        self.isAgreeAllRowHidden = isAgreeAllRowHidden
        self.isRightArrowHidden = isRightArrowHidden
        self.leadingInset = leadingInset
        super.init(frame: frame, style: .plain)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        estimatedRowHeight = 44
        rowHeight = UITableView.automaticDimension
        dataSource = self
        delegate = self
        
        register(AgreementCheckCell.self, forCellReuseIdentifier: AgreementCheckCell.reuseIdentifier)
    }
}

extension AgreementCheckView: UITableViewDataSource, UITableViewDelegate {
    // MARK: DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agreementList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AgreementCheckCell.reuseIdentifier) as? AgreementCheckCell else {
            fatalError("AgreementCheckCell not dequeued properly")
        }
        let text = agreementList[indexPath.row]
        cell.setLabelText(text: text)
        cell.updateLeadingInset(inset: leadingInset)
        cell.setLabelStyle(font: cellFont, textColor: cellTextColor)
        return cell
    }
    
    // MARK: Select Cell
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(in: indexPath.section, indexPath.row)
    }
}
