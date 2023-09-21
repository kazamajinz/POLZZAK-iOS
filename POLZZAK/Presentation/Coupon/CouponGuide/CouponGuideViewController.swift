//
//  CouponGuideViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit
import SnapKit

final class CouponGuideViewController: BaseAlertViewController {
    enum Constants {
        static let buttonPadding = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 24)
        static let inprogressTitle = "‘선물 전’ 쿠폰은 무엇인가요?"
        static let inprogressContent = "아이가 도장판을 다 모아서 발급해준 선물 쿠폰에 대해, 보호자님이 아직 실제로 선물을 전달하지 않은 쿠폰입니다."
        static let completedTitle = "‘선물 완료’ 쿠폰은 무엇인가요?"
        static let completedContent = "아이가 도장판을 다 모아서 발급해준 선물 쿠폰에 대해, 보호자님이 실제로 선물을 전달해준 쿠폰입니다.\n\n아이가 선물을 받고 '선물 받기 완료'버튼을 눌러줘야 '선물 완료' 쿠폰으로 구분돼요."
        static let confirmButtonText = "이해됐어요"
        static let firstCompletedContentEmphasis = NSRange(location: 37, length: 10)
        static let secondCompletedContentEmphasis = NSRange(location: 58, length: 3)
        static let thirdCompletedContentEmphasis = NSRange(location: 69, length: 18)
        static let contentCompletedEmphasisRanges = [firstCompletedContentEmphasis, secondCompletedContentEmphasis, thirdCompletedContentEmphasis]
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .vertical, spacing: 40)
        return stackView
    }()
    
    private let inprogressQnaStackView: QnaStackView = {
        let stackView = QnaStackView()
        stackView.titleLabel.text = Constants.inprogressTitle
        stackView.contentLabel.setByCharWrapping(text: Constants.inprogressContent)
        return stackView
    }()
    
    private let completedQnaStackView: QnaStackView = {
        let stackView = QnaStackView()
        stackView.titleLabel.text = Constants.completedTitle
        stackView.contentLabel.setStyledText(text: Constants.completedContent, emphasisRanges: Constants.contentCompletedEmphasisRanges, color: .gray600, font: .body14Bd, lineBreakMode: .byCharWrapping)
        return stackView
    }()
    
    let confirmButton: PaddedLabel = {
        let confirmButton = PaddedLabel(padding: Constants.buttonPadding)
        confirmButton.setLabel(text: Constants.confirmButtonText, textColor: .white, font: .subtitle16Sbd, textAlignment: .center, backgroundColor: .blue500)
        confirmButton.addBorder(cornerRadius: 8)
        confirmButton.isUserInteractionEnabled = true
        return confirmButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
}

extension CouponGuideViewController {
    private func setupUI() {
        [inprogressQnaStackView, completedQnaStackView, confirmButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions() {
        confirmButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmButtonTapped)))
    }
    
    @objc private func confirmButtonTapped() {
        dismiss(animated: false, completion: nil)
    }
}
