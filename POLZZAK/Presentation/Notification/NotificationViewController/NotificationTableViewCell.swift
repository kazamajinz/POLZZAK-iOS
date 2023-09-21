//
//  NotificationTableViewCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/12.
//

import UIKit
import SnapKit

protocol NotificationTableViewCellDelegate: AnyObject {
    func didTapAcceptButton(_ cell: NotificationTableViewCell)
    func didTapRejectButton(_ cell: NotificationTableViewCell)
    func didTapRemoveButton(_ cell: NotificationTableViewCell)
}

class NotificationTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NotificationTableViewCell"
    weak var delegate: NotificationTableViewCellDelegate?
    
    private let panGestureView = UIView()
    
    private let cellStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle18Sbd
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .subtitle16Bd)
        return label
    }()
    
    private let circleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .circle4
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray500, font: .caption12Md)
        return label
    }()
    
    private let newAlertImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .circle6
        imageView.isHidden = true
        return imageView
    }()
    
    private let titleView = UIView()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = UIApplication.shared.width - (16 * 4)
        label.textColor = .gray700
        label.font = .body14Sbd
        label.textAlignment = .natural
        return label
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let acceptButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: "수락", color: .white, font: .body16Md, backgroundColor: .blue500)
        button.addBorder(cornerRadius: 8)
        return button
    }()
    
    private let rejectButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: "거절", color: .white, font: .body16Md, backgroundColor: .error500)
        button.addBorder(cornerRadius: 8)
        return button
    }()
    
    private let completionView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setImage(.trashButton, for: .normal)
        return button
    }()
    
    private let completionSubView = UIView()
    private let completionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .blue500
        return imageView
    }()
    private let completionLabel = UILabel()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 11
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfileCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray500, font: .caption12Md)
        return label
    }()
    
    private let bottomView = UIStackView()
    private var isSwipeRemove = true
    var originalCenterCheck = false
    var isSwipe = false
    var swipeOnOriginalCenter = CGFloat()
    var swipeOffOriginalCenter = CGFloat()
    var beganOriginalCenter = CGFloat()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUI()
        setAction()
        setupSwipeToDeleteGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.addBorder(cornerRadius: profileImageView.bounds.width / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetUI()
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let panGestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer {
            let velocity = panGestureRecognizer.velocity(in: self
            )
            return abs(velocity.y) < abs(velocity.x)
        }
        return true
    }
    
    private func setupSwipeToDeleteGesture() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
        gesture.delegate = self
        panGestureView.addGestureRecognizer(gesture)
    }
    
    @objc func handleSwipeGesture(gesture: UIPanGestureRecognizer) {
        if false == isSwipeRemove {
            return
        }
        
        if false == originalCenterCheck {
            originalCenterCheck = true
            self.swipeOnOriginalCenter = panGestureView.center.x - 56
            self.swipeOffOriginalCenter = panGestureView.center.x
        }
        
        let originalCenter = isSwipe ? swipeOnOriginalCenter : swipeOffOriginalCenter
        let translationX = gesture.translation(in: panGestureView).x
        
        if gesture.state == .began {
            beganOriginalCenter = panGestureView.center.x
        }
        
        if gesture.state == .changed {
            if originalCenter > panGestureView.center.x {
                if beganOriginalCenter + translationX <= originalCenter {
                    panGestureView.center.x = beganOriginalCenter + translationX
                }  else if translationX >= 0 {
                    panGestureView.center.x = swipeOffOriginalCenter
                }
            } else {
                if false == isSwipe {
                    if panGestureView.center.x > beganOriginalCenter + translationX {
                        panGestureView.center.x = beganOriginalCenter + translationX
                    }
                } else {
                    if swipeOffOriginalCenter >= beganOriginalCenter + translationX {
                        panGestureView.center.x = beganOriginalCenter + translationX
                    } else {
                        panGestureView.center.x = swipeOffOriginalCenter
                    }
                }
            }
        } else if gesture.state == .ended {
            if translationX < -20 {
                isSwipe = true
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.panGestureView.center.x = self?.swipeOnOriginalCenter ?? 0
                })
            } else if translationX > 10  {
                isSwipe = false
                UIView.animate(withDuration: 0.2, animations: { [weak self] in
                    self?.panGestureView.center.x = self?.swipeOffOriginalCenter ?? 0
                })
            } else {
                panGestureView.center.x = (isSwipe ? swipeOnOriginalCenter : swipeOffOriginalCenter)
            }
        }
    }
}

extension NotificationTableViewCell {
    private func setUI() {
        selectionStyle = .none
        contentView.backgroundColor = .error500
        panGestureView.backgroundColor = .white
        
        contentView.addBorder(cornerRadius: 8)
        panGestureView.addBorder(cornerRadius: 8)
        
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(16)
            $0.width.height.equalTo(24)
        }
        
        contentView.addSubview(panGestureView)
        panGestureView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        panGestureView.addSubview(cellStackView)
        cellStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        
        cellStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(16)
            $0.trailing.bottom.equalToSuperview().inset(16)
        }
        
        [headerStackView, buttonStackView, completionView, bottomView].forEach {
            cellStackView.addArrangedSubview($0)
        }
        
        [titleView, descriptionLabel].forEach {
            headerStackView.addArrangedSubview($0)
        }
        
        [emojiLabel, titleLabel, circleImageView, dateLabel, newAlertImage].forEach {
            titleView.addSubview($0)
        }
        
        emojiLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(emojiLabel.snp.trailing).offset(4)
        }
        
        circleImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(7)
            $0.width.height.equalTo(4)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(circleImageView.snp.trailing).offset(7)
        }
        
        titleView.snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        newAlertImage.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.width.height.equalTo(6)
        }
        
        [acceptButton, rejectButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        completionView.addSubview(completionSubView)
        
        completionSubView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(8)
        }
        
        [completionImageView, completionLabel].forEach {
            completionSubView.addSubview($0)
        }
        
        completionImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }
        
        completionLabel.snp.makeConstraints {
            $0.leading.equalTo(completionImageView.snp.trailing).offset(8)
            $0.top.trailing.bottom.equalToSuperview()
        }
        
        [profileImageView, nicknameLabel].forEach {
            bottomView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.height.equalTo(24)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4)
        }
        
    }
    
    func configure(data: NotificationData) {
        if data.title.startsWithEmoji {
            let dataTitle = data.title.components(separatedBy: " ")
            emojiLabel.text = dataTitle[0]
            titleLabel.text = dataTitle[1]
        } else {
            titleLabel.text = data.title
        }
        
        dateLabel.text = data.createdDate.remainingTimeToString()
        
        newAlertImage.isHidden = data.status == .read
        descriptionLabel.text = data.message.boldTagRemove()
        if let emphasisRange = data.message.boldTagRanges() {
            descriptionLabel.setEmphasisRanges(emphasisRange, color: .gray800, font: .body14Sbd)
        }
        
        guard let type = data.type else { return }
        buttonStackView.isHidden = type.isButtonHidden
        bottomView.isHidden = type.isSenderHidden
        
        guard let sender = data.sender else { return }
        nicknameLabel.text = sender.nickname
        profileImageView.loadImage(from: sender.profileURL)
        
        switch data.status {
        case .read:
            newAlertImage.isHidden = true
        case .unread:
            newAlertImage.isHidden = false
        case .requestLink:
            isSwipeRemove = false
        case .requestAccept:
            updateUIForCompletion(true)
        case .requestReject:
            updateUIForCompletion(false)
        default:
            break
        }
    }
    
    private func resetUI() {
        buttonStackView.isHidden = false
        completionView.isHidden = true
        bottomView.isHidden = false
        emojiLabel.text = nil
        titleLabel.text = nil
        dateLabel.text = nil
        descriptionLabel.text = nil
        nicknameLabel.text = nil
        completionLabel.text = nil
        isSwipeRemove = true
        
    }
    
    private func updateUIForCompletion(_ bool: Bool) {
        if true == bool {
            completionImageView.image = .acceptButton?.withRenderingMode(.alwaysTemplate)
            completionLabel.setLabel(text: "수락했어요",textColor: .blue500, font: .subtitle16Bd)
            completionView.addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .blue500)
        } else {
            completionImageView.image = .rejectButton
            completionLabel.setLabel(text: "거절했어요",textColor: .error500, font: .subtitle16Bd)
            completionView.addBorder(cornerRadius: 8, borderWidth: 1, borderColor: .error500)
        }
        
        buttonStackView.isHidden = true
        completionView.isHidden = false
        isSwipeRemove = true
    }
    
    private func setAction() {
        acceptButton.addTarget(self, action: #selector(acceptButtonTapped), for: .touchUpInside)
        rejectButton.addTarget(self, action: #selector(rejectButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    @objc private func acceptButtonTapped() {
        delegate?.didTapAcceptButton(self)
        updateUIForCompletion(true)
        
    }
    
    @objc private func rejectButtonTapped() {
        delegate?.didTapRejectButton(self)
        updateUIForCompletion(false)
    }
    
    @objc private func deleteButtonTapped() {
        delegate?.didTapRemoveButton(self)
    }
}
