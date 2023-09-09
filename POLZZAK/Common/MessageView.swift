//
//  MessageView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/09.
//

import UIKit
import SnapKit

class MessageView: UIView {
    enum MessageViewType {
        case request
        case completed
        
        var label: String {
//            let userType =
            switch self {
            case .request:
                return "쿠폰을 발급해주세요!"
            case .completed:
                return "쿠폰 발급 완료!"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .request:
                return .requestGradationView
            case .completed:
                return .completedGradationView
            }
        }
    }
    
    private let gradationView = UIImageView()
    
    private let gradationLabel: PaddedLabel = {
        let label = PaddedLabel(padding: UIEdgeInsets(top: 4, left: 16, bottom: 11, right: 16))
        label.textColor = .white
        label.font = .body14Sbd
        label.textAlignment = .center
        return label
    }()
    
    init(type: MessageViewType) {
        super.init(frame: .zero)
        setupUI()
        setupType(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension MessageView {
    private func setupUI() {
        addSubview(gradationView)
        gradationView.addSubview(gradationLabel)
        
        gradationView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        gradationLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupType(type: MessageViewType) {
        gradationLabel.text = type.label
        gradationView.image = type.image
    }
}
