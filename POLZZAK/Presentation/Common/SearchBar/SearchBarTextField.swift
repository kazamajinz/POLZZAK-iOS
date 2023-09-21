//
//  SearchBarTextField.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/12.
//

import UIKit

final class SearchBarTextField: UITextField {
    var onActivationChange: (() -> Void)?
    var onSearch: ((String) -> Void)?
    
    let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .searchButton
        return imageView
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchBarTextField {
    private func configure() {
        delegate = self
        clearButtonMode = .whileEditing
        rightViewMode = .unlessEditing
        rightView = searchImageView
    }
    
    func textFieldActivate(bool: Bool, keyboard: Bool = true) {
        if true == bool {
            textColor = .gray800
            if true == keyboard {
                DispatchQueue.main.async {
                    self.becomeFirstResponder()
                }
            }
        } else {
            textColor = .gray500
        }
        isEnabled = bool
    }
}

extension SearchBarTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onActivationChange?()
        searchImageView.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            onActivationChange?()
            searchImageView.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            onSearch?(searchText)
        }
        textField.endEditing(true)
        return true
    }
}

