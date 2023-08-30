//
//  StampChoiceBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/30.
//

import Combine
import Foundation
import UIKit

import CombineCocoa

final class StampChoiceBottomSheetViewController: UIViewController {
    private var cancellables = Set<AnyCancellable>()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .blue500
        button.setTitle("다음", for: .normal)
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
        configureLayout()
        configureBinding()
    }
    
    private func configureView() {
        view.backgroundColor = .blue150
    }
    
    private func configureLayout() {
        [nextButton].forEach {
            view.addSubview($0)
        }
        
        nextButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func configureBinding() {
        nextButton.tapPublisher
            .sink { [weak self] _ in
                
            }
            .store(in: &cancellables)
    }
}
