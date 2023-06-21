//
//  SearchResultView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/21.
//

import UIKit
import SnapKit

protocol SearchResultViewDelegate: AnyObject {
    func linkRequest(alertStyle: LinkAlertStyle, memberId: Int)
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
    
    var button: ColorButton = {
        let button = ColorButton(buttonStyle: .LinkRequestBlue500)
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
    
    func setStyle(style: SearchResultState) {
        switch style {
        case .unlinked(let familyMember):
            self.familyMember = familyMember
            imageView.loadImage(from: style.imageURL)
            imageView.setCustomView(cornerRadius: style.cornerRadious)
        case .linked(let familyMember):
            self.familyMember = familyMember
            imageView.loadImage(from: style.imageURL)
            imageView.setCustomView(cornerRadius: style.cornerRadious)
        case .nonExist(_):
            imageView.image = .sittingCharacter
            imageView.setCustomView()
        case .notSearch:
            break
        }
        
        if let style = style.placeholder {
            placeholder.setLabel(style: style)
        }
        
        updateUI(style: style)
        setAction(style: style)
    }
    
    func setAction(style: SearchResultState) {
        switch style {
        case .unlinked, .linked:
            button.addTarget(self, action: #selector(linkRequest), for: .touchUpInside)
        default:
            break
        }
        underLineButton.addTarget(self, action: #selector(linkRequestCancel), for: .touchUpInside)
    }
    
    @objc private func linkRequest() {
        if let nickName = familyMember?.nickName, let memberId = familyMember?.memberId {
            delegate?.linkRequest(alertStyle: LinkAlertStyle.linkRequest(nickName), memberId: memberId)
        }
    }
    
    @objc private func linkRequestCancel() {
        if let memberId = familyMember?.memberId {
            delegate?.linkRequestCancel(memberId: memberId)
        }
    }
    
    func updateUI(style: SearchResultState) {
        imageView.snp.updateConstraints {
            self.imageViewSize = $0.width.height.equalTo(style.imageViewSize).constraint
        }
        
        button.snp.updateConstraints {
            self.buttonWidth = $0.width.equalTo(style.buttonWidth).constraint
        }
        
        if let buttonStyle = style.buttonStyle {
            button.configure(style: buttonStyle)
        }
        
        button.setTitle(style.buttonTitle, for: .normal)
    }
    
    func requestCompletion() {
        guard let familyMember = familyMember else { return }
        updateUI(style: SearchResultState.linked(familyMember))
        underLineButton.isHidden = false
    }
    
    func requestCancel() {
        guard let familyMember = familyMember else { return }
        updateUI(style: SearchResultState.unlinked(familyMember))
        underLineButton.isHidden = true
    }
}
