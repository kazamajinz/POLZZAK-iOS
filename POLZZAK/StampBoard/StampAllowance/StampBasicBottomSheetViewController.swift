//
//  StampBasicBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/01.
//

import Combine
import UIKit

import CombineCocoa
import PanModal

class StampBasicBottomSheetViewController: UIViewController, PanModalPresentable {
    private enum Constants {
        static let basicInset: CGFloat = 16
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .subtitle16Sbd
        return label
    }()
    
    private let stepLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .body13Md
        return label
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private static let buttonAttributes: [NSAttributedString.Key : Any] = [
        .font: UIFont.subtitle16Sbd,
        .foregroundColor: UIColor.white
    ]
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .gray300
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 8
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        [titleLabel, stepLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        [leftButton, rightButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [labelStackView, contentView, buttonStackView].forEach {
            view.addSubview($0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.bottom.equalTo(buttonStackView.snp.top).offset(-10)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constants.basicInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
    
    // MARK: - PanModalPresentable
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeight
    }
}

// MARK: - For Inherited Object

extension StampBasicBottomSheetViewController {
    final func setContentView(view: UIView) {
        contentView.addSubview(view)
        
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    final func setTitleLabel(text: String?) {
        titleLabel.text = text
    }
    
    final func setStepLabel(text: String?) {
        stepLabel.text = text
    }
    
    final func setRightButton(text: String) {
        let titleAttrStr = NSAttributedString(string: text, attributes: Self.buttonAttributes)
        rightButton.setAttributedTitle(titleAttrStr, for: .normal)
    }
    
    final func setLeftButton(text: String) {
        let titleAttrStr = NSAttributedString(string: text, attributes: Self.buttonAttributes)
        leftButton.setAttributedTitle(titleAttrStr, for: .normal)
    }
    
    final func setRightButtonTapAction(action: @escaping (() -> Void)) {
        rightButton.tapPublisher
            .sink(receiveValue: action)
            .store(in: &cancellables)
    }
    
    final func setLeftButtonTapAction(action: @escaping (() -> Void)) {
        leftButton.tapPublisher
            .sink(receiveValue: action)
            .store(in: &cancellables)
    }
}
