//
//  TextCheckView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/15.
//

import Foundation

import Combine
import UIKit

import CombineCocoa

final class TextCheckView: UIView {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var validText: String? = nil
    @Published private var currentCheckViewStatus: ViewStatus = .initial
    
    private let type: TextCheckViewType
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle16Sbd
        label.text = "이름"
        label.textAlignment = .left
        return label
    }()
    
    private let textField = CheckTextField()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .caption12Sbd
        label.text = "이미 사용되고 있는 닉네임이에요"
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .caption12Sbd
        label.text = "0/10"
        label.textAlignment = .right
        label.textColor = .gray500
        label.isHidden = true
        return label
    }()
    
    var text: String? {
        return textField.text
    }
    
    init(frame: CGRect = .zero, type: TextCheckViewType) {
        self.type = type
        super.init(frame: frame)
        configureView()
        configureLayout()
        configureTextField()
        configureBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        titleLabel.text = type.title
        textField.setPlaceholder(text: type.placeholderText)
        
        [descriptionLabel, countLabel].forEach {
            $0.isHidden = true
        }
        
        switch type {
        case .stampBoardName, .compensation:
            titleLabel.isHidden = false
        case .mission:
            titleLabel.isHidden = true
        }
    }
    
    private func configureLayout() {
        
        // MARK: -
        
        addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // MARK: -
        
        [titleLabel, textField, labelStackView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(type.textFieldHeight)
        }
        
        // MARK: -
        
        [descriptionLabel, countLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        countLabel.setContentHuggingPriority(.init(1001), for: .horizontal)
        countLabel.setContentCompressionResistancePriority(.init(1001), for: .horizontal)
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
                setCheckViewUI(status: status)
            }
            .store(in: &cancellables)
        
        textField.firstResponderChanged
            .sink { [weak self] _ in
                guard let self else { return }
                setCheckViewUI(status: currentCheckViewStatus)
            }
            .store(in: &cancellables)
    }
    
    private func configureTextField() {
        textField.delegate = self
    }
    
    private func checkValidity(text: String?) -> ViewStatus {
        guard let text, !text.isEmpty else { return .nilOrEmpty(description: type.descriptionNilOrEmpty) }
        guard text.count >= type.minCharacters else { return .lessThanNCharacter(n: type.minCharacters) }
        guard text.count <= type.maxCharacters else { return .overNCharacters(n: type.maxCharacters) }
        return .pass
    }
    
    private func setCheckViewUI(status: ViewStatus) {
        let isTextFieldFirstResponder = textField.isFirstResponder
        descriptionLabel.text = status.description
        countLabel.isHidden = !isTextFieldFirstResponder
        
        switch status {
        case .initial:
            textField.layer.borderColor = isTextFieldFirstResponder ? UIColor.blue500.cgColor : UIColor.gray300.cgColor
            descriptionLabel.isHidden = true
        case .pass:
            textField.layer.borderColor = isTextFieldFirstResponder ? UIColor.blue500.cgColor : UIColor.gray300.cgColor
            descriptionLabel.textColor = .blue500
            descriptionLabel.isHidden = !isTextFieldFirstResponder
        default:
            textField.layer.borderColor = UIColor.error500.cgColor
            descriptionLabel.textColor = .error500
            descriptionLabel.isHidden = false
        }
    }
    
    private func setCountLabelText(textCount: Int?) {
        let count: Int
        if textCount == nil {
            count = 0
        } else {
            count = textCount!
        }
        countLabel.text = "\(count)/\(type.maxCharacters)"
    }
}

extension TextCheckView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text, text.count + string.count <= type.maxCharacters else {
            setCheckViewUI(status: .overNCharacters(n: type.maxCharacters))
            return false
        }
        return true
    }
}

// MARK: - Nested Types

extension TextCheckView {
    enum ViewStatus {
        case initial
        case nilOrEmpty(description: String)
        case lessThanNCharacter(n: Int)
        case overNCharacters(n: Int)
        case pass
        
        var description: String? {
            switch self {
            case .lessThanNCharacter(let n): return "최소 \(n)글자는 작성해야 돼요"
            case .nilOrEmpty(let description): return description
            case .overNCharacters(let n): return "\(n)자까지만 쓸 수 있어요"
            default: return nil
            }
        }
    }
}

// MARK: - TextCheckViewType

enum TextCheckViewType {
    case stampBoardName
    case compensation
    case mission
    
    var title: String? {
        switch self {
        case .stampBoardName:
            return "이름"
        case .compensation:
            return "보상"
        case .mission:
            return nil
        }
    }
    
    var textFieldHeight: CGFloat {
        switch self {
        case .stampBoardName:
            return 50
        case .compensation:
            return 50
        case .mission:
            return 45
        }
    }
    
    var minCharacters: Int {
        switch self {
        case .stampBoardName:
            return 2
        case .compensation:
            return 1
        case .mission:
            return 1
        }
    }
    
    var maxCharacters: Int {
        switch self {
        case .stampBoardName:
            return 20
        case .compensation:
            return 30
        case .mission:
            return 20
        }
    }
    
    var descriptionNilOrEmpty: String {
        switch self {
        case .stampBoardName:
            return "도장판 이름을 입력해주세요"
        case .compensation:
            return "보상을 입력해주세요"
        case .mission:
            return "빈칸이 있어요!"
        }
    }
    
    var placeholderText: String {
        switch self {
        case .stampBoardName:
            return "도장판 이름을 입력해주세요"
        case .compensation:
            return "도장판을 다 모으면 어떤 선물을 줄까요?"
        case .mission:
            return "미션을 입력해주세요"
        }
    }
}
