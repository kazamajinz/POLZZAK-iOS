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
    weak var delegate: FilterBottomSheetDelegate?
    
    var selectedIndex: Int = 0
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: "누구에게 선물한 쿠폰을 볼까요?", textColor: .gray700, font: .subtitle16Sbd)
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(FilterBottomCell.self, forCellReuseIdentifier: FilterBottomCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: -4, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    var data: [FamilyMember] = []
    var currentFilterValue = 0
    
    override var initialHeight: CGFloat {
        return self.view.frame.height / 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        transitioningDelegate = self
        
        setUI()
        selectedCell()
    }
    
    private func setUI() {
        view.addCornerRadious(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], cornerRadius: 12)
        
        [textLabel, tableView].forEach {
            view.addSubview($0)
        }
        
        textLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(38)
            $0.centerX.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(textLabel.snp.bottom).offset(16)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func selectedCell() {
        tableView.selectRow(at: IndexPath(row: 0, section: selectedIndex), animated: false, scrollPosition: .none)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: FilterBottomCell.reuseIdentifier, for: indexPath) as! FilterBottomCell
        indexPath.section == 0 ? cell.configure(with: "전체") : cell.configure(with: data[indexPath.section - 1].nickName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedItem(index: indexPath.section)
        self.dismiss(animated: true, completion: nil)
    }

}
