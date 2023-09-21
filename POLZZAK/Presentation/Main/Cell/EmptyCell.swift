//
//  EmptyCell.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/05/29.
//

import UIKit
import SnapKit

final class EmptyCell: UICollectionViewCell {
    static let reuseIdentifier = "EmptyCell"
    
    enum Constants {
        static let deviceWidth = UIApplication.shared.width
        static let imageViewWidth = deviceWidth * 60.0 / 375.0
        
        enum inprogress {
            static let placeholdText = "님과\n진행 중인 도장판이 없어요"
        }
        
        enum completed {
            static let childPlaceholdText = "완료된 도장판이 없어요"
            static let parentPlaceholdText = "님은 아직\n완료된 도장판이 없어요"
        }
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.setStackView(axis: .vertical, spacing: 8)
        return stackView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .sittingCharacter
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let placeholdLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray700, font: .body14Md, textAlignment: .center)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addDashedBorder(borderColor: .gray300, spacing: 3, cornerRadius: 8)
    }
}

extension EmptyCell {
    private func setUI() {
        backgroundColor = .white
        
        [imageView, placeholdLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.height.equalTo(Constants.imageViewWidth)
        }
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(80)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with nickname: String, tabState: TabState, userType: UserType) {
        switch tabState {
        case .inProgress:
            placeholdLabel.text = "\(nickname)" + Constants.inprogress.placeholdText
            let emphasisRange = [NSRange(location: 0, length: nickname.count)]
            placeholdLabel.setEmphasisRanges(emphasisRange, color: .gray700, font: .body14Bd)
        case .completed:
            if userType == .child {
                placeholdLabel.text = Constants.completed.childPlaceholdText
                let emphasisRange = [NSRange(location: 0, length: nickname.count)]
                placeholdLabel.setEmphasisRanges(emphasisRange, color: .gray700, font: .body14Bd)
            } else {
                placeholdLabel.text = "\(nickname)" + Constants.completed.parentPlaceholdText
            }
        }
    }
}
