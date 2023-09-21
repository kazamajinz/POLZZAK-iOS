//
//  CheckTextField.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import Combine
import UIKit

import CombineCocoa

final class CheckTextField: UITextField {
    enum FirstResponderEvent {
        case become
        case resign
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let _firstResponderChanged = PassthroughSubject<FirstResponderEvent, Never>()
    private let _cancelImageViewTapped = PassthroughSubject<Void, Never>()
    
    var firstResponderChanged: AnyPublisher<FirstResponderEvent, Never> {
        _firstResponderChanged.eraseToAnyPublisher()
    }
    
    var cancelImageViewTapped: AnyPublisher<Void, Never> {
        _cancelImageViewTapped.eraseToAnyPublisher()
    }
    
    private let cancelImageView = UIImageView(image: UIImage(named: "cancel.circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var rect = super.caretRect(for: position)
        let size = CGSize(width: 1.8, height: 15)
        let y = rect.origin.y + abs(rect.size.height-size.height)/2
        rect = .init(origin: .init(x: rect.origin.x, y: y), size: size)
        return rect
    }
    
    // 붙여넣기 기능 비활성화
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func becomeFirstResponder() -> Bool {
        let become = super.becomeFirstResponder()
        _firstResponderChanged.send(.become)
        return become
    }
    
    override func resignFirstResponder() -> Bool {
        let resign = super.resignFirstResponder()
        _firstResponderChanged.send(.resign)
        cancelImageView.isHidden = true
        return resign
    }
    
    private func configureView() {
        tintColor = .black
        backgroundColor = .white
        borderStyle = .none
        layer.borderColor = UIColor.gray300.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 8
        attributedPlaceholder = NSAttributedString(
            string: "닉네임을 입력해주세요",
            attributes: [
                .foregroundColor: UIColor.gray400,
                .font: UIFont.body14Md
            ]
        )
        leftView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 1))
        leftViewMode = .always
        cancelImageView.frame = .init(x: 16, y: 12, width: 20, height: 20)
        cancelImageView.isHidden = true
        cancelImageView.contentMode = .scaleAspectFill
        let container = UIView(frame: .init(x: 0, y: 0, width: 52, height: 44))
        container.addSubview(cancelImageView)
        rightView = container
        rightViewMode = .always
    }
    
    private func configureBinding() {
        cancelImageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        cancelImageView.addGestureRecognizer(tapGesture)
        
        tapGesture.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                text = nil
                cancelImageView.isHidden = true
                _cancelImageViewTapped.send()
            }
            .store(in: &cancellables)
        
        textPublisher
            .sink { [weak self] text in
                guard let self else { return }
                if text == nil || text!.isEmpty {
                    cancelImageView.isHidden = true
                } else {
                    cancelImageView.isHidden = false
                }
            }
            .store(in: &cancellables)
    }
    
    func setPlaceholder(text: String) {
        attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: UIColor.gray400,
                .font: UIFont.body14Md
            ]
        )
    }
}
