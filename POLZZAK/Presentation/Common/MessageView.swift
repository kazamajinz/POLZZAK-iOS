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
        case issuedCoupon
        case rewarded
        
        var label: String {
            switch self {
            case .request:
                return "쿠폰을 발급해주세요!"
            case .completed:
                return "쿠폰 선물이 있어요!"
            case .issuedCoupon:
                return "쿠폰 발급 완료!"
            case .rewarded:
                return "도장을 다 모았어요!"
            }
        }
        
        var image: UIImage? {
            switch self {
            case .request, .completed:
                return .requestGradationView
            case .issuedCoupon, .rewarded:
                return .completedGradationView
            }
        }
    }
    
    private let gradationView = UIImageView()
    
    private let gradationLabel: PaddedLabel = {
        let label = PaddedLabel(padding: UIEdgeInsets(top: 4, left: 16, bottom: 12, right: 16))
        label.textColor = .white
        label.font = .body14Sbd
        label.textAlignment = .center
        return label
    }()
    
    var type: MessageViewType? {
        didSet {
            setupType(type: type)
        }
    }

    init() {
        super.init(frame: .zero)
        setupUI()
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
    
    private func setupType(type: MessageViewType?) {
        guard let type else { return }
        gradationLabel.text = type.label
        gradationView.image = type.image
    }
}
