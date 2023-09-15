//
//  TitleLoadingViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/13.
//

import UIKit

final class TitleLoadingViewController: UIViewController {
    private let contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle16Bd
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let loadingView = LoadingView()
    
    init(titleText: String?) {
        super.init(nibName: nil, bundle: nil)
        titleLabel.text = titleText
        if titleText == nil {
            titleLabel.isHidden = true
        }
        configureModalStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoading()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        [titleLabel, loadingView].forEach {
            contentView.addArrangedSubview($0)
        }
        
        view.addSubview(contentView)
        
        let statusBarHeight = UIApplication.shared.statusBarHeight
        contentView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-statusBarHeight)
        }
    }
    
    private func startLoading() {
        contentView.isHidden = false
        loadingView.startRotating()
    }
    
    private func stopLoading() {
        contentView.isHidden = true
        loadingView.stopRotating()
    }
    
    private func configureModalStyle() {
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }
}
