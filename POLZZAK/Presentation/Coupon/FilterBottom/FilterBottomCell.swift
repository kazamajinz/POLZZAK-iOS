//
//  FilterBottomCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/16.
//

import UIKit
import SnapKit

final class FilterBottomCell: UITableViewCell {
    static let reuseIdentifier = "FilterBottomCell"
    
    let contentsView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .gray200)
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .body14Sbd)
        return label
    }()
    
    private let checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkmarkIcon
        imageView.isHidden = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            label.setLabel(textColor: .blue600, font: .body14Md)
            contentsView.addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .blue500)
            contentsView.backgroundColor = .blue100
        } else {
            label.setLabel(textColor: .gray800, font: .body14Sbd)
            contentsView.addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .gray200)
            contentsView.backgroundColor = .gray100
        }
        checkmarkImageView.isHidden = !selected
    }
    
    private func setUI() {
        selectionStyle = .none
        
        addSubview(contentsView)
        
        contentsView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(4)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        [label, checkmarkImageView].forEach {
            contentsView.addSubview($0)
        }
        
        label.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalTo(checkmarkImageView.snp.leading).inset(14)
        }
        
        checkmarkImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.trailing.equalToSuperview().inset(16)
            $0.width.equalTo(checkmarkImageView.snp.height)
        }
    }
    
    func configure(with name: String) {
        label.text = name
    }
}
