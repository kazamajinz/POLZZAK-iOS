//
//  Toast.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/22.
//

import UIKit
import SnapKit

struct Toast {
    var style: LabelStyleProtocol
    var image: UIImage?
    
    let toastContainer: UIView = {
        let view = UIView()
        view.alpha = 0
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let imageView = UIImageView()
    let toastLabel = UILabel()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()

    init(style: LabelStyleProtocol, image: UIImage? = nil) {
        self.style = style
        self.image = image
        configuration()
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
        if image != nil {
            stackView.addArrangedSubview(imageView)
            imageView.snp.makeConstraints {
                $0.width.height.equalTo(20)
            }
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
    
    private func configuration() {
        toastContainer.backgroundColor = style.backgroundColor
        toastLabel.setLabel(style: style)
        imageView.image = image
    }
}
