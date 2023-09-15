//
//  Toast.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/22.
//

import UIKit
import SnapKit
class Toast: NSObject {
    enum Constants {
        static let toastHeight = 42.0
        static let bottomPadding = 36.0
        static let toastStartTime = 0.5
        static let toastEndTime = 0.5
        static let toastDuringTime = 2.0
    }
    
    private var currentCloseTask: Task<Void, Never>?
    
    var isToastShown: Bool = false
    
    private var type: ToastType?
    
    private let toastContainer: UIView = {
        let view = UIView()
        view.alpha = 1
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    
    private let toastLabel: UILabel = {
        let label = UILabel()
        label.font = .body14Sbd
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    init(type: ToastType) {
        super.init()
        
        setupToast(type: type)
    }
}

extension Toast {
    func setUI() {
        [imageView, toastLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        toastContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(Constants.toastHeight)
            $0.bottom.equalToSuperview().inset(type == .qatest("", nil) ? 100 : Constants.bottomPadding)
        }
        
        toastContainer.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            if type == .qatest("", nil) {
                $0.top.bottom.equalToSuperview()
            } else {
                $0.centerY.equalToSuperview()
            }
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setupToast(type: ToastType) {
        switch type {
        case .success(let text, let image):
            toastLabel.text = text
            toastContainer.backgroundColor = .blue600
            if let img = image {
                imageView.image = img
            } else {
                let acceptButton = UIImage.acceptButton?.withRenderingMode(.alwaysTemplate)
                imageView.image = acceptButton
            }
        case .error(let text, let image):
            toastLabel.text = text
            toastContainer.backgroundColor = .error500
            if let img = image {
                imageView.image = img
            } else {
                imageView.image = UIImage.informationButton
            }
        case .qatest(let text, let image):
            toastContainer.backgroundColor = .red
            toastLabel.text = text
            if let img = image {
                imageView.image = img
            } else {
                imageView.image = UIImage.informationButton
            }
            self.type = type
        }
    }
    
    func setGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        toastContainer.addGestureRecognizer(panGesture)
    }
    
    func show() {
        guard false == isToastShown else  { return }
        guard let topViewController = UIApplication.getTopViewController() else { return }
        topViewController.view.addSubview(toastContainer)
        isToastShown = true
        
        setUI()
        setGesture()
        
        self.toastContainer.transform = CGAffineTransform(translationX: 0, y: Constants.toastHeight + Constants.bottomPadding)
        
        UIView.animate(withDuration: Constants.toastStartTime, delay: 0.0, options: .curveEaseIn, animations: {
            self.toastContainer.alpha = 1.0
            self.toastContainer.transform = .identity
        }, completion: { [weak self] _ in
            guard let self = self else { return }
            self.startCloseTask()
        })
    }
    
    func startCloseTask() {
        currentCloseTask = Task.init(priority: .userInitiated, operation: { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(Constants.toastDuringTime * 1_000_000_000))
            if self?.currentCloseTask?.isCancelled == true { return }
            await self?.closeToast()
        })
    }
    
    @MainActor @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: toastContainer)
        if recognizer.state == .changed {
            toastContainer.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            self.currentCloseTask?.cancel()
            if translation.y > 0 {
                closeToast()
            } else {
                UIView.animate(withDuration: Constants.toastStartTime) {
                    self.toastContainer.transform = .identity
                }
            }
        }
    }
    
    @MainActor private func closeToast() {
        UIView.animate(withDuration: Constants.toastEndTime, animations: {
            self.toastContainer.alpha = 0.0
            self.toastContainer.transform = CGAffineTransform(translationX: 0, y: self.toastContainer.frame.height)
        }) { _ in
            self.toastContainer.removeFromSuperview()
            self.toastContainer.transform = .identity
            self.isToastShown = false
        }
    }
}
