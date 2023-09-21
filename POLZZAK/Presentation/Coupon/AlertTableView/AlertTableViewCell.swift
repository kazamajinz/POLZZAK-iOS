//
//  AlertTableViewCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/21.
//

import UIKit
import SnapKit

final class AlertTableViewCell: UITableViewCell {
    static let reuseIdentifier = "AlertTableViewCell"
    
    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        selectionStyle = .none
        
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
    }
}
