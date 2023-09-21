//
//  SearchBar.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/12.
//

import UIKit

protocol SearchBarDelegate: AnyObject {
    func searchBarDidBeginEditing(_ searchBar: SearchBar)
    func searchBarDidEndEditing(_ searchBar: SearchBar)
    func search(_ searchBar: SearchBar, searchText: String)
}

final class SearchBar: UIView {
    weak var delegate: SearchBarDelegate?
    
    let searchBarSubView = SearchBarSubView()
    
    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
    var isCancelState = false
    
    var placeholder: String = "" {
        didSet {
            searchBarSubView.placeholder = placeholder
        }
    }
    
    var textColor: UIColor = .gray800 {
        didSet {
            searchBarSubView.textColor = textColor
        }
    }
    
    var font: UIFont = .body14Md {
        didSet {
            searchBarSubView.font = font
        }
    }
    
    var searchImage: UIImage? = .searchButton {
        didSet {
            searchBarSubView.searchImage = searchImage
        }
    }
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: "취소", color: .gray600, font: .body14Sbd)
        return button
        
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        
        configure()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
}

extension SearchBar {
    private func configure() {
        [searchBarSubView, cancelButton].forEach {
            addSubview($0)
        }
        
        searchBarSubView.onActivationChange = { [weak self] in
            guard let self = self else { return }
            self.isCancelState.toggle()
            if false == self.isCancelState {
                self.delegate?.searchBarDidEndEditing(self)
            } else {
                self.delegate?.searchBarDidBeginEditing(self)
            }
            self.setNeedsLayout()
        }
        
        searchBarSubView.onSearch = { [weak self] text in
            guard let self = self else { return }
            self.delegate?.search(self, searchText: text)
            self.cancelButtonActivate(bool: text == "")
            self.searchBarSubView.searchBarTextField.textFieldActivate(bool: text == "")
        }
        
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func updateUI() {
        if false == isCancelState {
            searchBarSubView.animateFrameChange(to: bounds)
            cancelButton.animateFrameChange(to: CGRect(x: bounds.width + 49, y: 0, width: 49, height: bounds.height))
        } else {
            searchBarSubView.animateFrameChange(to: CGRect(x: 0, y: 0, width: bounds.width - 49, height: bounds.height))
            cancelButton.animateFrameChange(to: CGRect(x: bounds.width - 41, y: 0, width: 49, height: bounds.height))
        }
    }
    
    func activate(bool: Bool, keyboard: Bool = true) {
        cancelButtonActivate(bool: bool)
        searchBarSubView.searchBarTextField.textFieldActivate(bool: bool, keyboard: keyboard)
    }
    
    private func cancelButtonActivate(bool: Bool) {
        if true == bool {
            cancelButton.setTitleColor(.gray600, for: .normal)
        } else {
            cancelButton.setTitleColor(.gray400, for: .normal)
        }
        cancelButton.isEnabled = bool
    }
    
    @objc private func cancelButtonTapped() {
        searchBarSubView.searchBarTextField.text = ""
        searchBarSubView.searchBarTextField.endEditing(true)
        delegate?.searchBarDidEndEditing(self)
        isCancelState = false
        updateUI()
    }
}
