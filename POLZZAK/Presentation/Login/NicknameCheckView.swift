//
//  NicknameCheckView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import Combine
import UIKit

import CombineCocoa

final class NicknameCheckView: UIView {
    /// NicknameCheckResult는 StatusCode (Int) 임
    typealias NicknameCheckResult = Int
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var validText: String? = nil
    @Published private var currentCheckViewStatus: CheckViewStatus = .initial
    
    private let upperStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let textField = CheckTextField()
    
    private let checkButton: UIButton = {
        let button = UIButton(type: .custom)
        var config = UIButton.Configuration.plain()
        button.configuration = config
        button.layer.cornerRadius = 8
        button.backgroundColor = .error200
        return button
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nickname_check")
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.text = "이미 사용되고 있는 닉네임이에요"
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.text = "0/10"
        label.textAlignment = .right
        label.textColor = .gray500
        label.isHidden = true
        return label
    }()
    
    var text: String? {
        return textField.text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureTextField()
        configureBinding()
        setCheckButton(status: currentCheckViewStatus)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        addSubview(upperStackView)
        addSubview(labelStackView)
        addSubview(countLabel)
        
        [textField, checkButton].forEach {
            upperStackView.addArrangedSubview($0)
        }
        
        [checkImageView, descriptionLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        // TODO: width를 상수로 하는게 적합할지 생각해보고 적합하지 않다면 바꾸기
        checkButton.snp.makeConstraints { make in
            make.width.equalTo(78)
        }
        
        upperStackView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.horizontalEdges.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(upperStackView.snp.bottom).offset(4)
            make.leading.equalTo(textField).inset(8)
            make.trailing.lessThanOrEqualTo(countLabel.snp.leading)
        }
        
        // TODO: width를 상수로 하는게 적합할지 생각해보고 적합하지 않다면 바꾸기
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.top.equalTo(upperStackView.snp.bottom).offset(4)
            make.trailing.equalTo(textField).inset(8)
        }
        
        snp.makeConstraints { make in
            make.bottom.greaterThanOrEqualTo(labelStackView)
            make.bottom.greaterThanOrEqualTo(countLabel)
        }
    }
    
    private func configureBinding() {
        Publishers.Merge(textField.controlEventPublisher(for: .editingChanged), textField.cancelImageViewTapped)
            .sink { [weak self] _ in
                guard let self else { return }
                validText = nil
                setCountLabelText(textCount: text?.count)
                let checkViewStatus = checkValidity(text: text)
                currentCheckViewStatus = checkViewStatus
            }
            .store(in: &cancellables)
        
        $currentCheckViewStatus
            .sink { [weak self] status in
                guard let self else { return }
                setCheckButton(status: status)
                setCheckViewUI(status: status)
            }
            .store(in: &cancellables)
        
        textField.firstResponderChanged
            .sink { [weak self] _ in
                guard let self else { return }
                setCheckViewUI(status: currentCheckViewStatus)
            }
            .store(in: &cancellables)
        
        checkButton.tapPublisher
            .sink { [weak self] in
                Task { [weak self] in
                    guard let self, let text else { return }
                    let result = await checkNicknameValid(nickname: text)
                    setUIOnNicknameValidation(checkResult: result)
                }
            }
            .store(in: &cancellables)
    }
    
    private func checkNicknameValid(nickname text: String) async -> NicknameCheckResult? {
        guard let (_, response) = try? await AuthAPI.checkNicknameDuplicate(nickname: text) else { return nil }
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        return statusCode
    }
    
    private func setUIOnNicknameValidation(checkResult code: NicknameCheckResult?) {
        guard let code else { return }
        
        if code == 204 {
            currentCheckViewStatus = .passAndChecked
            validText = text
        } else if code == 400 {
            currentCheckViewStatus = .checkedButInvalid
            validText = nil
        }
    }
    
    private func configureTextField() {
        textField.delegate = self
    }
    
    private func checkValidity(text: String?) -> CheckViewStatus {
        guard let text, !text.isEmpty else { return .nilOrEmpty }
        let range = NSRange(location: 0, length: text.count)
        let regex = try! NSRegularExpression(pattern: "^[가-힣a-zA-Z0-9]+$")
        guard regex.firstMatch(in: text, range: range) != nil else { return .notAllowedCharacterIncluded }
        guard text.count >= 2 else { return .lessThan2Character }
        guard text.count <= 10 else { return .over10Characters }
        return .pass
    }
    
    private func setCheckViewUI(status: CheckViewStatus) {
        let isTextFieldFirstResponder = textField.isFirstResponder
        descriptionLabel.text = status.description
        countLabel.isHidden = !isTextFieldFirstResponder
        
        switch status {
        case .initial:
            textField.layer.borderColor = isTextFieldFirstResponder ? UIColor.blue500.cgColor : UIColor.gray300.cgColor
            descriptionLabel.isHidden = true
            checkImageView.isHidden = true
        case .passAndChecked:
            textField.layer.borderColor = isTextFieldFirstResponder ? UIColor.blue500.cgColor : UIColor.gray300.cgColor
            descriptionLabel.textColor = .blue500
            descriptionLabel.isHidden = false
            checkImageView.isHidden = false
        case .pass:
            textField.layer.borderColor = isTextFieldFirstResponder ? UIColor.blue500.cgColor : UIColor.gray300.cgColor
            descriptionLabel.textColor = .blue500
            descriptionLabel.isHidden = !isTextFieldFirstResponder
            checkImageView.isHidden = true
        default:
            textField.layer.borderColor = UIColor.error500.cgColor
            descriptionLabel.textColor = .error500
            descriptionLabel.isHidden = false
            checkImageView.isHidden = true
        }
    }
    
    private func setCheckButton(status: CheckViewStatus) {
        let titleAttrs = AttributeContainer([
            .font: UIFont.body2,
            .foregroundColor: UIColor.white,
        ])
        
        switch status {
        case .pass:
            checkButton.configuration?.attributedTitle = AttributedString("중복 확인", attributes: titleAttrs)
            checkButton.configuration?.background.backgroundColor = .blue500
            checkButton.isEnabled = true
        case .passAndChecked:
            checkButton.configuration?.attributedTitle = AttributedString("사용 가능", attributes: titleAttrs)
            checkButton.configuration?.background.backgroundColor = .blue200
            checkButton.isEnabled = false
        default:
            checkButton.configuration?.attributedTitle = AttributedString("중복 확인", attributes: titleAttrs)
            checkButton.configuration?.background.backgroundColor = .gray300
            checkButton.isEnabled = false
        }
    }
    
    private func setCountLabelText(textCount: Int?) {
        let count: Int
        if textCount == nil {
            count = 0
        } else {
            count = textCount!
        }
        countLabel.text = "\(count)/10"
    }
}

extension NicknameCheckView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text, text.count + string.count <= 10 else {
            setCheckViewUI(status: .over10Characters)
            return false
        }
        return true
    }
}

// MARK: - Nested Types

extension NicknameCheckView {
    enum CheckViewStatus {
        case initial
        case nilOrEmpty
        case lessThan2Character
        case over10Characters
        case notAllowedCharacterIncluded
        case pass
        case passAndChecked
        case checkedButInvalid
        
        var description: String? {
            switch self {
            case .lessThan2Character, .nilOrEmpty: return "최소 2글자로 설정해주세요"
            case .over10Characters: return "10자까지만 쓸 수 있어요"
            case .notAllowedCharacterIncluded: return "특수문자(공백)는 쓸 수 없어요"
            case .passAndChecked: return "사용 가능한 닉네임이에요"
            case .checkedButInvalid: return "이미 사용되고 있는 닉네임이에요"
            default: return nil
            }
        }
    }
}
