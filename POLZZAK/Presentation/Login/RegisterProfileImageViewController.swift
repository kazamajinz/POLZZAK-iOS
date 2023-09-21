//
//  RegisterProfileImageViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/22.
//

import Combine
import UIKit
import PhotosUI

import CombineCocoa
import SnapKit

final class RegisterProfileImageViewController: UIViewController {
    enum Constants {
        static let basicInset: CGFloat = 16
        static let button1Image = UIImage(named: "select_profile_image1")
    }
    
    private let registerModel: RegisterModel
    private let viewModel: RegisterProfileImageViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let descriptionLabel1: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray800
        label.font = .title22Bd
        label.text = "프로필 사진을 설정해주세요"
        return label
    }()
    
    private let descriptionLabel2: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .gray600
        label.font = .body15Md
        label.text = "나중에 설정해도 괜찮아요\n미설정 시 기본 사진으로 설정돼요"
        label.numberOfLines = 2
        label.setLineSpacing(spacing: 5)
        return label
    }()
    
    private let selectImageButton1: UIButton = {
        let button = UIButton(type: .custom)
        button.setImageForButton(Constants.button1Image)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }()
    
    private let selectImageButton2: UIButton = {
        let button = UIButton(type: .custom)
        button.setImageForButton(UIImage(named: "select_profile_image2"))
        return button
    }()
    
    private let nextButton: RegisterNextButton = {
        let nextButton = RegisterNextButton()
        nextButton.setTitle(text: "회원가입 완료")
        return nextButton
    }()
    
    private var imagePicker: PHPickerViewController?
    private var loadedImage: UIImage?
    
    init(registerModel: RegisterModel) {
        self.registerModel = registerModel
        self.viewModel = .init(registerModel: registerModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureView()
        configureImagePicker()
        configureBinding()
    }
    
    private func configureLayout() {
        let pivotView = UIView()
        let imageContainerView = UIView()
        
        [labelStackView, pivotView, nextButton].forEach {
            view.addSubview($0)
        }
        
        [descriptionLabel1, descriptionLabel2].forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        pivotView.addSubview(imageContainerView)
        [selectImageButton1, selectImageButton2].forEach {
            imageContainerView.addSubview($0)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
        }
        
        pivotView.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        let selectImageButton1Height: CGFloat = 127
        let selectImageButton2Height: CGFloat = 28
        
        imageContainerView.snp.makeConstraints { make in
            make.height.width.equalTo(selectImageButton1Height)
            make.centerY.equalToSuperview().multipliedBy(0.8)
            make.centerX.equalToSuperview()
        }
        
        selectImageButton1.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectImageButton2.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.width.equalTo(selectImageButton2Height)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(Constants.basicInset)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.basicInset)
            make.height.equalTo(50)
        }
        
        selectImageButton1.layer.cornerRadius = selectImageButton1Height / 2
        selectImageButton2.layer.cornerRadius = selectImageButton2Height / 2
        selectImageButton1.clipsToBounds = true
        selectImageButton2.clipsToBounds = true
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
    }
    
    private func configureImagePicker() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images
        imagePicker = PHPickerViewController(configuration: config)
        imagePicker?.delegate = self
    }
    
    private func configureBinding() {
        Publishers.Merge(selectImageButton1.tapPublisher, selectImageButton2.tapPublisher)
            .sink { [weak self] in
                guard let self else { return }
                guard let imagePicker else { return }
                self.present(imagePicker, animated: true)
            }
            .store(in: &cancellables)
        
        nextButton.tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                nextButton.isEnabled = false
                nextButton.setTitle(text: "회원가입 처리 중 ...")
                viewModel.input.send(.register)
            }
            .store(in: &cancellables)
        
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { output in
                switch output {
                case .showMain:
                    AppFlowController.shared.showLoading() // TODO: 이 부분은 폴짝의 세계로! 로딩이 보여야 함
                }
            }
            .store(in: &cancellables)
    }
}

extension RegisterProfileImageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self else { return }
                setLoadedImage(image as? UIImage)
            }
        } else {
            setLoadedImage(Constants.button1Image)
        }
    }
    
    func setLoadedImage(_ image: UIImage?) {
        loadedImage = image
        registerModel.profileImage = loadedImage
        DispatchQueue.main.async {
            self.selectImageButton1.setImageForButton(self.loadedImage)
        }
    }
}

fileprivate extension UIButton {
    func setImageForButton(_ image: UIImage?) {
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
}
