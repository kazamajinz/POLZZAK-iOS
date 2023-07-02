//
//  SearchResultView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/21.
//

import UIKit
import SnapKit

protocol SearchResultViewDelegate: AnyObject {
    func linkRequest(nickName: String, memberId: Int)
    func linkRequestCancel(memberId: Int)
}

final class SearchResultView: UIView {
    private var imageViewSize: Constraint?
    private var buttonWidth: Constraint?
    weak var delegate: SearchResultViewDelegate?
    var familyMember: FamilyMember?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfileCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    var button: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .caption3
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        return button
    }()
    
    var underLineButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        let labelStyle = LabelStyle(text: "앗 실수, 요청 취소 할래요", textColor: .gray500, font: .body9, textAlignment: .center)
        button.setUnderlinedTitle(labelStyle: labelStyle)
        return button
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    private func setUI() {
        isHidden = true
        backgroundColor = .white
        
        [imageView, placeholder, button, underLineButton].forEach {
            addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(175)
            $0.centerX.equalToSuperview()
            self.imageViewSize = $0.width.height.equalTo(100).constraint
        }
        
        placeholder.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(placeholder.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            self.buttonWidth = $0.width.equalTo(100).constraint
            $0.height.equalTo(32)
        }
        
        underLineButton.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setType(type: SearchResultState) {
        switch type {
        case .unlinked(let member):
            familyMember = member
            imageView.loadImage(from: member.profileURL)
            imageView.setCustomView(cornerRadius: 45.5)
            placeholder.setLabel(text: member.nickName, textColor: .black, font: .body5)
            button.setTitleLabel(title: "연동요청", color: .white, font: .caption3)
            button.setButtonView(backgroundColor: .blue500, cornerRadius: 4)
            updateButtonUI(imageViewSize: 91, buttonWidth: 93)
            button.addTarget(self, action: #selector(linkRequest), for: .touchUpInside)
        case .linked(let member):
            familyMember = member
            imageView.loadImage(from: member.profileURL)
            imageView.setCustomView(cornerRadius: 45.5)
            placeholder.setLabel(text: member.nickName, textColor: .black, font: .body5)
            button.setTitleLabel(title: "이미 연동됐어요", color: .gray400, font: .caption3)
            button.setButtonView(borderColor: .gray400, cornerRadius: 4, borderWidth: 1)
            updateButtonUI(imageViewSize: 91, buttonWidth: 124)
            button.removeTarget(self, action: #selector(linkRequest), for: .touchUpInside)
        case .linkedRequestComplete(let member):
            familyMember = member
            imageView.loadImage(from: member.profileURL)
            imageView.setCustomView(cornerRadius: 45.5)
//            placeholder.setLabel(text: member.nickName, textColor: .black, font: .body5)
            button.setTitleLabel(title: "연동 요청 완료!", color: .blue500, font: .caption3)
            button.setButtonView(borderColor: .blue500, cornerRadius: 4, borderWidth: 1)
            updateButtonUI(imageViewSize: 91, buttonWidth: 120)
            button.removeTarget(self, action: #selector(linkRequest), for: .touchUpInside)
        case .nonExist(let nickName):
            imageView.image = .sittingCharacter
            let emphasisRange = NSRange(location: 0, length: nickName.count)
            let emphasisLabelStyle = EmphasisLabelStyle(text: "\(nickName)님을\n찾을 수 없어요", textColor: .gray700, font: .body3, textAlignment: .center, emphasisRange: emphasisRange, emphasisColor: .gray700, emphasisFont: .body5)
            placeholder.setLabel(style: emphasisLabelStyle)
            updateButtonUI(imageViewSize: 100)
        case .notSearch:
            break
        }
        
        underLineButton.addTarget(self, action: #selector(linkRequestCancel), for: .touchUpInside)
    }
    
    @objc private func linkRequest() {
        if let nickName = familyMember?.nickName, let memberId = familyMember?.memberId {
            delegate?.linkRequest(nickName: nickName, memberId: memberId)
        }
    }
    
    @objc private func linkRequestCancel() {
        if let memberId = familyMember?.memberId {
            delegate?.linkRequestCancel(memberId: memberId)
        }
    }
    
    func updateButtonUI(imageViewSize: CGFloat, buttonWidth: CGFloat = 0) {
        imageView.snp.updateConstraints {
            self.imageViewSize = $0.width.height.equalTo(imageViewSize).constraint
        }
        
        button.snp.updateConstraints {
            self.buttonWidth = $0.width.equalTo(buttonWidth).constraint
        }
    }
    
    func requestCompletion() {
        guard let familyMember = familyMember else { return }
//        updateUI(style: SearchResultState.linked(familyMember))
        setType(type: .linkedRequestComplete(familyMember))
        underLineButton.isHidden = false
    }
    
    func requestCancel() {
        guard let familyMember = familyMember else { return }
//        updateUI(style: SearchResultState.unlinked(familyMember))
        setType(type: .unlinked(familyMember))
        underLineButton.isHidden = true
    }
}
