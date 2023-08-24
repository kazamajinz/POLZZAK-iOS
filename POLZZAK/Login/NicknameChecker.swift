//
//  NicknameChecker.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import Combine
import UIKit

import CombineCocoa

final class NicknameChecker: UIView {
    @Published var progressAllowed: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let otherEditTextField = PassthroughSubject<Void, Never>()
    
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
    
    private let textField = NicknameTextField()
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureTextField()
        configureBinding()
        setCheckButton(status: .inactive)
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
        // cancelImageViewTapped인 경우, textPublisher에서 text가 nil인 경우와 동작이 같아서
        // cancelImageViewTapped를 String?을 방출하는 publisher로 설정해서 nil을 방출하게 하였음
        textField.controlEventPublisher(for: .editingChanged).merge(with: otherEditTextField)
            .sink { [weak self] _ in
                guard let self else { return }
                let text = textField.text
                setCheckButton(status: .inactive)
                setCountLabelText(textCount: text?.count)
                let validationResult = checkValidity(text: text)
                print(validationResult)
                setCheckerUI(validationResult: validationResult)
                
                switch validationResult {
                case .pass:
                    setCheckButton(status: .active)
                default:
                    setCheckButton(status: .inactive)
                }
            }
            .store(in: &cancellables)
        
        textField.firstResponderChanged
            .sink { [weak self] firstResponderEvent in
                guard let self else { return }
                switch firstResponderEvent {
                case .become:
                    textField.layer.borderColor = UIColor.blue500.cgColor
                    countLabel.isHidden = false
                case .resign:
                    countLabel.isHidden = true
                    otherEditTextField.send(())
                }
            }
            .store(in: &cancellables)
        
        textField.cancelImageViewTapped
            .sink { [weak self] _ in
                self?.otherEditTextField.send(())
            }
            .store(in: &cancellables)
        
        checkButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                // TODO: 추후에 처리
                // 닉네임체크 api 부르고
                // 그 결과에 따라
                // 성공이면 setCheckButton(status: .checked)
                // 실패면 setCheckButton(status: .inactive)
                
                // 성공 가정
                setCheckButton(status: .checked)
                setCheckerUI(validationResult: .passAndChecked)
                progressAllowed = true
            }
            .store(in: &cancellables)
        
        // TODO: 아래 TapGesture를 RegisterNicknameViewController로 옮기기
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        addGestureRecognizer(tapGesture)
        
        tapGesture.tapPublisher
            .sink { [weak self] _ in
                self?.endEditing(true)
            }
            .store(in: &cancellables)
    }
    
    private func configureTextField() {
        textField.delegate = self
    }
    
    private func checkValidity(text: String?) -> ValidationResult {
        guard let text, !text.isEmpty else { return .nilOrEmpty }
        let range = NSRange(location: 0, length: text.count)
        let regex = try! NSRegularExpression(pattern: "^[가-힣a-zA-Z0-9]+$")
        guard regex.firstMatch(in: text, range: range) != nil else { return .notAllowedCharacterIncluded }
        guard text.count >= 2 else { return .lessThan2Character }
        guard text.count <= 10 else { return .over10Characters }
        return .pass
    }
    
    private func setCheckerUI(validationResult: ValidationResult) {
        descriptionLabel.text = validationResult.description
        
        switch validationResult {
        case .passAndChecked:
            textField.layer.borderColor = UIColor.blue500.cgColor
            descriptionLabel.textColor = .blue500
            descriptionLabel.isHidden = false
            checkImageView.isHidden = false
        case .pass:
            textField.layer.borderColor = UIColor.blue500.cgColor
            descriptionLabel.textColor = .blue500
            descriptionLabel.isHidden = true
            checkImageView.isHidden = true
        default:
            textField.layer.borderColor = UIColor.error500.cgColor
            descriptionLabel.textColor = .error500
            descriptionLabel.isHidden = false
            checkImageView.isHidden = true
        }
    }
    
    private func setCheckButton(status: CheckButtonStatus) {
        let titleAttrs = AttributeContainer([
            .font: UIFont.body2,
            .foregroundColor: UIColor.white,
        ])
        
        switch status {
        case .active:
            checkButton.configuration?.attributedTitle = AttributedString("중복 확인", attributes: titleAttrs)
            checkButton.configuration?.background.backgroundColor = .blue500
            checkButton.isEnabled = true
        case .inactive:
            checkButton.configuration?.attributedTitle = AttributedString("중복 확인", attributes: titleAttrs)
            checkButton.configuration?.background.backgroundColor = .gray300
            checkButton.isEnabled = false
        case .checked:
            checkButton.configuration?.attributedTitle = AttributedString("사용 가능", attributes: titleAttrs)
            checkButton.configuration?.background.backgroundColor = .blue200
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

extension NicknameChecker: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text, text.count + string.count <= 10 else {
            setCheckerUI(validationResult: .over10Characters)
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        progressAllowed = false
    }
}

// MARK: - Nested Types

extension NicknameChecker {
    enum ValidationResult {
        case nilOrEmpty
        case lessThan2Character
        case over10Characters
        case notAllowedCharacterIncluded
        case pass
        case passAndChecked
        
        var description: String? {
            switch self {
            case .lessThan2Character, .nilOrEmpty: return "최소 2글자로 설정해주세요"
            case .over10Characters: return "10자까지만 쓸 수 있어요"
            case .notAllowedCharacterIncluded: return "특수문자(공백)는 쓸 수 없어요"
            case .passAndChecked: return "사용 가능한 닉네임이에요"
            default: return nil
            }
        }
    }
    
    enum CheckButtonStatus {
        case active
        case inactive
        case checked
    }
}
