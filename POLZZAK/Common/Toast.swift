//
//  Toast.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/22.
//

import UIKit
import SnapKit

struct Toast {
    private let toastContainer: UIView = {
        let view = UIView()
        view.alpha = 0
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .error500
        return view
    }()
    
    private let imageView = UIImageView()
    
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

    init(image: UIImage? = .informationButton, text: String) {
        imageView.image = image
        imageView.tintColor = .white
        toastLabel.text = text
    }

    func show(controller: UIViewController) {
        controller.view.addSubview(toastContainer)
        setUI()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            self.toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 3.0, options: .curveEaseOut, animations: {
                self.toastContainer.alpha = 0.0
            }, completion: {_ in
                self.toastContainer.removeFromSuperview()
            })
        })
    }
    
    func setUI() {
        stackView.addArrangedSubview(imageView)
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        
        stackView.addArrangedSubview(toastLabel)
        
        toastContainer.addSubview(stackView)
        
        toastContainer.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(36)
        }

        stackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(11)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
