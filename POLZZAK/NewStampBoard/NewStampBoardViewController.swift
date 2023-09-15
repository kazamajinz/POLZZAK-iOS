//
//  NewStampBoardViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/15.
//

import UIKit

final class NewStampBoardViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    private let nameTextCheckView = TextCheckView(type: .stampBoardName)
    private let compensationTextCheckView = TextCheckView(type: .compensation)
    private let stampSizeSelectionView = StampSizeSelectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
    }
    
    private func configureView() {
        view.backgroundColor = .white
    }
    
    private func configureLayout() {
        
        // MARK: -
        
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        // MARK: -
        
        scrollView.addSubview(contentStackView)
        
        contentStackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview().inset(16)
        }
        
        // MARK: -
        let emptyView = UIView()
        emptyView.backgroundColor = .green
        
        [nameTextCheckView, compensationTextCheckView, stampSizeSelectionView, emptyView].forEach {
            contentStackView.addArrangedSubview($0)
        }
        
        nameTextCheckView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        compensationTextCheckView.snp.makeConstraints { make in
            make.height.equalTo(100)
        }
        
        stampSizeSelectionView.snp.makeConstraints { make in
            make.height.equalTo(134)
        }
        
        emptyView.snp.makeConstraints { make in
            make.height.equalTo(600)
        }
    }
}
