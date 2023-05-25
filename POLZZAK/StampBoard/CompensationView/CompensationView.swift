//
//  CompensationView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/25.
//

import UIKit

import SnapKit

class CompensationView: UIView {
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let compensationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "coupon")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let compensationLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle3
        label.textAlignment = .left
        label.text = "보상"
        return label
    }()
    
    private let prizeLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle1
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .body4
        label.textAlignment = .center
        label.textColor = .gray500
        label.text = "도장판을 다 채우면 쿠폰을 발급해줄 수 있어요."
        return label
    }()
    
    private let issuingButtton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .subtitle3
        titleContainer.foregroundColor = .white
        config.attributedTitle = AttributedString("쿠폰 발급하기", attributes: titleContainer)
        config.background.cornerRadius = 8
        config.cornerStyle = .fixed
        button.configuration = config
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = .blue200
            case .normal:
                button.configuration?.background.backgroundColor = .blue500
            default:
                return
            }
        }
        return button
    }()
    
    private let deleteStampBoardButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var titleContainer = AttributeContainer()
        titleContainer.font = .pretendard(size: 13, family: .semiBold)
        titleContainer.foregroundColor = .gray500
        titleContainer.underlineColor = .gray500
        titleContainer.underlineStyle = .single
        config.attributedTitle = AttributedString("도장판 삭제하기", attributes: titleContainer)
        config.background.backgroundColor = .clear
        button.configuration = config
        return button
    }()
    
    private let horizontalInset: CGFloat
    
    init(frame: CGRect = .zero, title: String, horizontalInset: CGFloat = 0) {
        self.horizontalInset = horizontalInset
        super.init(frame: frame)
        configurView(prizeLabelTitle: title)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CompensationView {
    private func configurView(prizeLabelTitle: String) {
        prizeLabel.text = prizeLabelTitle
        backgroundColor = .white
    }
    
    private func configureLayout() {
        addSubview(contentView)
        contentView.addSubview(stackView)
        
        [compensationLabel,
         compensationImageView,
         prizeLabel,
         issuingButtton,
         descriptionLabel,
         deleteStampBoardButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.setCustomSpacing(26, after: prizeLabel)
        stackView.setCustomSpacing(36, after: descriptionLabel)
        stackView.setCustomSpacing(50, after: deleteStampBoardButton)
        
        contentView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        compensationImageView.snp.makeConstraints { make in
            make.height.equalTo(80)
        }
        
        issuingButtton.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
