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
    
    private let searchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .searchButton
        return imageView
    }()
    
    init(frame: CGRect = .zero, style: SearchBarStyle) {
        super.init(frame: frame)
        configure(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchBarTextField {
    private func configure(style: SearchBarStyle) {
        delegate = self
        
        placeholder = style.placeholder
        font = style.font
        clearButtonMode = .whileEditing
        rightView = searchImageView
        rightViewMode = .unlessEditing
    }
}

extension SearchBarTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        onActivationChange?()
        searchImageView.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        onActivationChange?()
        searchImageView.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text {
            print("Search for \(searchText)")
        }
        
        textField.resignFirstResponder()
        return true
    }
}

