//
//  Toast.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/22.
//

import UIKit
import SnapKit

class Toast: NSObject {
    enum ToastType {
        case success(String, UIImage? = nil)
        case error(String, UIImage? = nil)
    }
    
    enum Constants {
        static let toastHeight = 42.0
        static let bottomPadding = 36.0
        static let toastTime = 3.0
    }
    
    var isToastShown: Bool = false
    
    private var isManuallyClosed = false
    
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
        label.font = .body2
        label.textColor = .white
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
        
        switch type {
        case .success(let text, let image):
            setSuccessToast(successText: text)
            if let img = image {
                imageView.image = img
            }
        case .error(let text, let image):
            setErrorToast(errorText: text)
            if let img = image {
                imageView.image = img
            }
        }
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
            $0.bottom.equalToSuperview().inset(Constants.bottomPadding)
        }
        
        toastContainer.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setSuccessToast(successText: String) {
        toastLabel.text = successText
        toastContainer.backgroundColor = .blue600
        let acceptButton = UIImage.acceptButton?.withRenderingMode(.alwaysTemplate)
        imageView.image = acceptButton
    }
    
    func setErrorToast(errorText: String) {
        toastLabel.text = errorText
        toastContainer.backgroundColor = .error500
        imageView.image = UIImage.informationButton
    }
    
    func setGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        toastContainer.addGestureRecognizer(panGesture)
    }
    
    func show() {
        guard let topViewController = UIApplication.topViewController() else { return }
        topViewController.view.addSubview(toastContainer)
        
        isToastShown = true
        
        setUI()
        setGesture()
        self.toastContainer.transform = CGAffineTransform(translationX: 0, y: Constants.toastHeight + Constants.bottomPadding)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.toastContainer.alpha = 1.0
            self.toastContainer.transform = .identity
        }, completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.toastTime) { [weak self] in
                guard let self = self else { return }
                if false == self.isManuallyClosed {
                    self.closeToast()
                }
            }
        })
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: toastContainer)
        if recognizer.state == .changed {
            toastContainer.transform = CGAffineTransform(translationX: 0, y: translation.y)
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            if translation.y > 0 {
                isManuallyClosed = true
                closeToast()
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.toastContainer.transform = .identity
                }
            }
        }
    }
    
    private func closeToast() {
        UIView.animate(withDuration: 0.5, animations: {
            self.toastContainer.alpha = 0.0
            self.toastContainer.transform = CGAffineTransform(translationX: 0, y: self.toastContainer.frame.height)
        }) { _ in
            self.toastContainer.removeFromSuperview()
            self.toastContainer.transform = .identity
            self.isToastShown = false
        }
    }
}
