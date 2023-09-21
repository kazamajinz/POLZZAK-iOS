//
//  SearchBarSubView.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/12.
//

import UIKit

final class SearchBarSubView: UIView {
    var onActivationChange: (() -> Void)? {
        get {
            return searchBarTextField.onActivationChange
        }
        set {
            searchBarTextField.onActivationChange = {
                newValue?()
            }
        }
    }
    
    var onSearch: ((String) -> Void)? {
        get {
            return searchBarTextField.onSearch
        }
        set {
            searchBarTextField.onSearch = { text in
                newValue?(text)
            }
        }
    }
    
    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    let searchBarTextField = SearchBarTextField()
    
    var placeholder: String = "" {
        didSet {
            searchBarTextField.placeholder = placeholder
        }
    }
    
    var textColor: UIColor = .gray800 {
        didSet {
            searchBarTextField.textColor = textColor
        }
    }
    
    var font: UIFont = .body14Md {
        didSet {
            searchBarTextField.font = font
        }
    }
    
    var searchImage: UIImage? = .searchButton {
        didSet {
            searchBarTextField.searchImageView.image = searchImage
        }
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configure()
        searchBarTextField.frame = bounds.inset(by: padding)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchBarTextField.becomeFirstResponder()
    }
}

extension SearchBarSubView {
    private func configure() {
        addSubview(searchBarTextField)
        addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .gray300)
    }
}

