//
//  NicknameTextField.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/29.
//

import UIKit

class NicknameTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    // TODO: caret 사이즈 조절 다음에 하기
//    override func caretRect(for position: UITextPosition) -> CGRect {
//        var rect = super.caretRect(for: position)
//        rect.size.height = 16
//        return rect
//    }
    
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
                .font: UIFont.body3
            ]
        )
        leftView = UIView(frame: .init(x: 0, y: 0, width: 16, height: 1))
        leftViewMode = .always
        let imageView = UIImageView(image: UIImage(named: "cancel.circle"))
        imageView.frame = .init(x: 16, y: 12, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFill
        let container = UIView(frame: .init(x: 0, y: 0, width: 52, height: 44))
        container.addSubview(imageView)
        rightView = container
        rightViewMode = .whileEditing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
