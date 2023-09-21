//
//  IssueCouponBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/06.
//

import Combine
import UIKit

import CombineCocoa
import PanModal

final class IssueCouponBottomSheetViewController: UIViewController {
    private enum Constants {
        static let basicInset: CGFloat = 16
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blue600
        label.font = .subtitle18Sbd
        label.text = "2023 콘서트 티켓"
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .subtitle16Sbd
        label.text = "쿠폰이 활성화 되었어요!"
        return label
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    private let couponImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .blue200
        imageView.image = UIImage(named: "coupon")
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .caption12Md
        label.numberOfLines = 2
        label.textAlignment = .center
        label.text = "언제까지 선물을 주실 예정인가요?\n선물 예정일은 수정이 불가하니 신중하게 정해주세요."
        return label
    }()
    
    private let dueContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray100
        view.layer.borderColor = UIColor.gray200.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let dueDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray500
        label.font = .body14Md
        label.textAlignment = .left
        label.text = "선물 예정일"
        return label
    }()
    
    private let dueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray800
        label.font = .body14Md
        label.textAlignment = .right
        label.text = "날짜를 설정해주세요"
        return label
    }()
    
    private let dueCalenderButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "issue_stamp_calender")
        button.setImage(image, for: .normal)
        button.setImage(image, for: .highlighted)
        return button
    }()
    
    private let issueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue500
        button.layer.cornerRadius = 8
        let title = NSAttributedString(
            string: "쿠폰 발급하기",
            attributes: [
            .font: UIFont.subtitle16Sbd,
            .foregroundColor: UIColor.white
        ])
        button.setAttributedTitle(title, for: .normal)
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
        configureBinding()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        
        // MARK: -
        
        [titleLabel, subtitleLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        // MARK: -
        
        [labelStackView, couponImageView, descriptionLabel, dueContentView, issueButton].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        contentStackView.setCustomSpacing(30, after: labelStackView)
        contentStackView.setCustomSpacing(30, after: couponImageView)
        contentStackView.setCustomSpacing(20, after: descriptionLabel)
        contentStackView.setCustomSpacing(10, after: dueContentView)
        
        couponImageView.snp.makeConstraints { make in
            make.height.width.equalTo(100)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        dueContentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        issueButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        
        couponImageView.layer.cornerRadius = 50
        
        // MARK: -
        
        [dueDescriptionLabel, dueLabel, dueCalenderButton].forEach {
            dueContentView.addSubview($0)
        }
        
        dueDescriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        dueLabel.snp.makeConstraints { make in
            make.leading.equalTo(dueDescriptionLabel.snp.trailing)
            make.verticalEdges.equalToSuperview()
        }
        
        dueCalenderButton.snp.makeConstraints { make in
            make.leading.equalTo(dueLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        
        dueDescriptionLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        dueCalenderButton.setContentHuggingPriority(.init(251), for: .horizontal)
        
        // MARK: -
        
        view.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
    
    private func configureBinding() {
        dueCalenderButton.tapPublisher
            .sink { [weak self] in
                let vc = GiftDueSelectViewController()
                vc.modalTransitionStyle = .crossDissolve
                self?.present(vc, animated: true)
            }
            .store(in: &cancellables)
        
        issueButton.tapPublisher
            .sink { [weak self] in
                let vc = TitleLoadingViewController(titleText: "쿠폰 발급 중")
                self?.present(vc, animated: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self?.presentedViewController?.dismiss(animated: true)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - PanModalPresentable

extension IssueCouponBottomSheetViewController: PanModalPresentable {
    var panScrollable: UIScrollView? {
        return nil
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(410)
    }
}
