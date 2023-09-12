//
//  FilterBottomSheetViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/16.
//

import UIKit
import SnapKit

protocol FilterBottomSheetDelegate: AnyObject {
    func selectedItem(index: Int)
}

final class FilterBottomSheetViewController: BottomSheetViewController {
    enum Constants {
        static let textLabel = "누구에게 선물한 쿠폰을 볼까요?"
        static let contentInset = UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0)
        static let cellHeight = 55.0
    }
    
    weak var delegate: FilterBottomSheetDelegate?
    var selectedIndex: Int = 0
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.textLabel, textColor: .gray700, font: .subtitle16Sbd)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(FilterBottomCell.self, forCellReuseIdentifier: FilterBottomCell.reuseIdentifier)
        tableView.contentInset = Constants.contentInset
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let data: [FamilyMember]
    
    init(data: [FamilyMember]) {
        self.data = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var initialHeight: CGFloat {
        return self.view.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setTableView()
        selectedCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        selectedCellScroll()
    }
    
    private func setUI() {
        transitioningDelegate = self
        
        view.addBorder(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], cornerRadius: 12)
        
        [textLabel, tableView].forEach {
            view.addSubview($0)
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(38)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func selectedCell() {
        let indexPath = IndexPath(row: 0, section: selectedIndex)
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    private func selectedCellScroll() {
        let indexPath = IndexPath(row: 0, section: selectedIndex)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension FilterBottomSheetViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard false == data.isEmpty else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterBottomCell.reuseIdentifier, for: indexPath) as! FilterBottomCell
        indexPath.section == 0 ? cell.configure(with: "전체") : cell.configure(with: data[indexPath.section - 1].nickname)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedItem(index: indexPath.section)
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }
}
