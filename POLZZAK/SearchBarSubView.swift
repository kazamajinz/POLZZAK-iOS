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
    let searchBarTextField: SearchBarTextField
    
    init(frame: CGRect = .zero, style: SearchBarStyle) {
        
        searchBarTextField = SearchBarTextField(style: style)
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        setCustomView(cornerRadius: 8, borderWidth: 1, borderColor: .gray300)
    }
}

