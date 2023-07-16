//
//  CustomSwitch.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/07/16.
//

import UIKit
import SnapKit

class CustomSwitch: UIControl {
    //TODO: - 모서리값 전달받으면 바꿔야함.
    private let circleDiameter: CGFloat = 18
    private let switchViewCornerRadius: CGFloat = 12
    private let onColor = UIColor.blue500
    private let offColor = UIColor.gray400
    
    var isSwitchOn = false {
        didSet {
            updateView()
        }
    }
    
    private let switchView: UIView = {
        let switchView = UIView()
        switchView.backgroundColor = .white
        switchView.layer.shadowColor = UIColor.black.cgColor
        switchView.layer.shadowOpacity = 0.5
        switchView.layer.shadowOffset = CGSize(width: 0.75, height: 2)
        switchView.layer.shadowRadius = 1.5
        return switchView
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
        setGesture()
    }
    
    private func setupUI() {
        layer.cornerRadius = switchViewCornerRadius
        switchView.layer.cornerRadius = circleDiameter / 2
        
        addSubview(switchView)
        
        switchView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(circleDiameter)
            $0.width.equalTo(circleDiameter)
            $0.leading.equalToSuperview().offset(3)
        }
    }
    
    private func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSwitch))
        addGestureRecognizer(tapGesture)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeSwitch))
        swipeRight.direction = .right
        addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeSwitch))
        swipeLeft.direction = .left
        addGestureRecognizer(swipeLeft)
    }
    
    private func updateView() {
        UIView.animate(withDuration: 0.3) {
            if self.isSwitchOn {
                self.switchView.snp.remakeConstraints { [weak self] make in
                    guard let self = self else { return }
                    make.centerY.equalToSuperview()
                    make.trailing.equalToSuperview().inset(3)
                    make.width.height.equalTo(circleDiameter)
                }
                self.backgroundColor = self.onColor
            } else {
                self.switchView.snp.remakeConstraints { [weak self] make in
                    guard let self = self else { return }
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview().offset(3)
                    make.width.height.equalTo(circleDiameter)
                }
                self.backgroundColor = self.offColor
            }
        }
        layoutIfNeeded()
    }
    
    @objc private func didTapSwitch() {
        self.isSwitchOn.toggle()
        self.sendActions(for: .valueChanged)
    }
    
    @objc private func didSwipeSwitch(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            self.isSwitchOn = false
        } else if gesture.direction == .right {
            self.isSwitchOn = true
        }
        self.sendActions(for: .valueChanged)
    }
}
