//
//  MissonAddTextFieldCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/16.
//

import UIKit

import SnapKit

class MissonAddTextFieldCell: UICollectionViewCell {
    static let reuseIdentifier = "MissonAddTextFieldCell"
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let textCheckView = TextCheckView(type: .mission)
    
    private let deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "misson_delete_image")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 20)
        button.configuration = config
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MissonAddTextFieldCell {
    private func configureView() {
        
    }
    
    private func configureLayout() {
        [textCheckView, deleteButton].forEach {
            contentView.addSubview($0)
        }
        
        textCheckView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.leading.equalTo(textCheckView.snp.trailing)
            make.height.equalTo(45)
            make.width.equalTo(36)
        }
        
        deleteButton.setContentHuggingPriority(.init(1001), for: .horizontal)
        deleteButton.setContentCompressionResistancePriority(.init(1001), for: .horizontal)
    }
}
