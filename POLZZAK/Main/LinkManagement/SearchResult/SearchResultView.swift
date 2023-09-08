//
//  SearchResultView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/21.
//

import UIKit
import SnapKit

protocol SearchResultViewDelegate: AnyObject {
    func linkRequest(nickName: String, memberID: Int)
    func linkRequestCancel(memberID: Int)
}

final class SearchResultView: UIView {
    weak var delegate: SearchResultViewDelegate?
    var familyMember: FamilyMember?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfileCharacter
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let placeholder: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .body14Md, textAlignment: .center)
        label.numberOfLines = 0
        return label
    }()
    
    let button = PaddedLabel(padding: UIEdgeInsets(top: 13, left: 12, bottom: 13, right: 12))
    
    var underLineButton: UIButton = {
        let button = UIButton()
        button.isHidden = true
        button.setUnderlinedTitle(text: "앗 실수, 요청 취소 할래요", textColor: .gray500, font: .body13Sbd)
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
            $0.width.height.equalTo(100)
        }
        
        placeholder.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.top.equalTo(placeholder.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(32)
            $0.width.greaterThanOrEqualTo(100)
        }
        
        underLineButton.snp.makeConstraints {
            $0.top.equalTo(button.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
    /*
    func handleSearchResult(for state: SearchResultState) {
        switch state {
        case .unlinked(let member):
            familyMember = member
            imageView.loadImage(from: member.profileURL)
            imageView.layer.cornerRadius = 50
            placeholder.setLabel(text: member.nickname, textColor: .black, font: .body14Bd)
            button.setLabel(text: "연동요청", textColor: .white, font: .caption12Bd, textAlignment: .center, backgroundColor: .blue500)
            button.addBorder(cornerRadius: 4)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkRequest))
            button.isUserInteractionEnabled = true
            button.addGestureRecognizer(tapGesture)

        case .linked(let member):
            familyMember = member
            imageView.loadImage(from: member.profileURL)
            imageView.layer.cornerRadius = 50
            placeholder.setLabel(text: member.nickname, textColor: .black, font: .body14Bd)
            button.setLabel(text: "이미 연동됐어요", textColor: .gray400, font: .caption12Bd, textAlignment: .center)
            button.addBorder(cornerRadius: 4, borderWidth: 1, borderColor: .gray400)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkRequest))
            button.isUserInteractionEnabled = true
            button.addGestureRecognizer(tapGesture)
        case .linkedRequestComplete(let member):
            familyMember = member
            imageView.loadImage(from: member.profileURL)
            imageView.layer.cornerRadius = 50
            button.setLabel(text: "연동 요청 완료!", textColor: .blue500, font: .caption12Bd, textAlignment: .center)
            button.addBorder(cornerRadius: 4, borderWidth: 1, borderColor: .blue400)
        case .nonExist(let nickname):
            imageView.image = .sittingCharacter
            imageView.layer.cornerRadius = 0
            placeholder.text = "\(nickname)님을\n찾을 수 없어요"
            let emphasisRange = [NSRange(location: 0, length: nickname.count)]
            placeholder.setEmphasisRanges(emphasisRange, color: .gray700, font: .body14Bd)
        case .notSearch:
            break
        }
        
        underLineButton.addTarget(self, action: #selector(linkRequestCancel), for: .touchUpInside)
    }
    */
    func handleSearchResult(for state: SearchResultState) {
        resetViews()
        switch state {
        case .unlinked(let member):
            setupUnlinked(member)
        case .linked(let member):
            setupLinked(member)
        case .linkRequestCompleted(let member):
            setupLinkedRequestComplete(member)
        case .nonExist(let nickname):
            setupNonExist(nickname)
        case .notSearch:
            break
        }
        underLineButton.addTarget(self, action: #selector(linkRequestCancel), for: .touchUpInside)
    }

    private func resetViews() {
        placeholder.setLabel(textColor: .gray700, font: .body14Md, textAlignment: .center)
        button.isHidden = true
        button.isUserInteractionEnabled = true
        button.gestureRecognizers?.forEach(button.removeGestureRecognizer)
        underLineButton.isHidden = true
        underLineButton.removeTarget(self, action: nil, for: .allEvents)
        imageView.layer.cornerRadius = 50
    }

    private func setupUnlinked(_ member: FamilyMember) {
        familyMember = member
        if let profileURL = member.profileURL {
            imageView.loadImage(from: profileURL)
        }
        imageView.layer.cornerRadius = 50
        placeholder.setLabel(text: member.nickname, textColor: .black, font: .body14Bd)
        button.isHidden = false
        button.setLabel(text: "연동요청", textColor: .white, font: .caption12Bd, textAlignment: .center, backgroundColor: .blue500)
        button.addBorder(cornerRadius: 4)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkRequest))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tapGesture)
        
        underLineButton.isHidden = true
    }

    private func setupLinked(_ member: FamilyMember) {
        familyMember = member
        if let profileURL = member.profileURL {
            imageView.loadImage(from: profileURL)
        }
        imageView.layer.cornerRadius = 50
        placeholder.setLabel(text: member.nickname, textColor: .black, font: .body14Bd)
        button.isHidden = false
        button.setLabel(text: "이미 연동됐어요", textColor: .gray400, font: .caption12Bd, textAlignment: .center)
        button.addBorder(cornerRadius: 4, borderWidth: 1, borderColor: .gray400)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkRequest))
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(tapGesture)
    }

    private func setupLinkedRequestComplete(_ member: FamilyMember?) {
        if let member {
            familyMember = member
            if let profileURL = member.profileURL {
                imageView.loadImage(from: profileURL)
            }
            imageView.layer.cornerRadius = 50
            placeholder.setLabel(text: member.nickname, textColor: .black, font: .body14Bd)
        }
        button.isHidden = false
        button.setLabel(text: "연동 요청 완료!", textColor: .blue500, font: .caption12Bd, textAlignment: .center)
        button.addBorder(cornerRadius: 4, borderWidth: 1, borderColor: .blue400)
        underLineButton.isHidden = false
    }

    private func setupNonExist(_ nickname: String) {
        imageView.image = .sittingCharacter
        imageView.layer.cornerRadius = 0
        placeholder.text = "\(nickname)님을\n찾을 수 없어요"
        let emphasisRange = [NSRange(location: 0, length: nickname.count)]
        placeholder.setEmphasisRanges(emphasisRange, color: .gray700, font: .body14Bd)
    }

    @objc private func linkRequest() {
        if let nickName = familyMember?.nickname, let memberID = familyMember?.memberID {
            delegate?.linkRequest(nickName: nickName, memberID: memberID)
        }
    }
    
    @objc private func linkRequestCancel() {
        if let memberID = familyMember?.memberID {
            delegate?.linkRequestCancel(memberID: memberID)
        }
    }
    
//    private func requestCompletion() {
//        guard let familyMember = familyMember else { return }
//        handleSearchResult(for: .linkRequestCompleted)
//    }

    func requestCancel() {
        guard let familyMember = familyMember else { return }
        handleSearchResult(for: .unlinked(familyMember))
        underLineButton.isHidden = true
    }
}
