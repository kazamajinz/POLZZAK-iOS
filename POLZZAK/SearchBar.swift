//
//  SearchBar.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/12.
//

import UIKit

final class SearchBar: UIView {
    private var onActivationChange: (() -> Void)? {
        get {
            return searchBarSubView.onActivationChange
        }
        set {
            searchBarSubView.onActivationChange = {
                newValue?()
            }
        }
    }
    
    private var onSearch: ((String) -> Void)? {
        get {
            return searchBarSubView.onSearch
        }
        set {
            searchBarSubView.onSearch = newValue
        }
    }
    
    private var isCancelState = true
    
    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    private let searchBarSubView: SearchBarSubView
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: "취소", color: .gray600, font: .body2)
        return button
        
    }()
    
    init(frame: CGRect = .zero, style: SearchBarStyle) {
        searchBarSubView = SearchBarSubView(style: style)
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if true == isCancelState {
            searchBarSubView.animateFrameChange(to: bounds)
            cancelButton.animateFrameChange(to: CGRect(x: bounds.width + 49, y: 0, width: 49, height: bounds.height))
        } else {
            searchBarSubView.animateFrameChange(to: CGRect(x: 0, y: 0, width: bounds.width - 49, height: bounds.height))
            cancelButton.animateFrameChange(to: CGRect(x: bounds.width - 49, y: 0, width: 49, height: bounds.height))
        }
    }
}

extension SearchBar {
    private func configure() {
        [searchBarSubView, cancelButton].forEach {
            addSubview($0)
        }
        
        searchBarSubView.onActivationChange = { [weak self] in
            self?.isCancelState.toggle()
            self?.setNeedsLayout()
        }
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    @objc private func cancelButtonTapped() {
        searchBarSubView.searchBarTextField.endEditing(true)
        self.setNeedsLayout()
    }
}
