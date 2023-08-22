//
//  CouponDetailViewController.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/17.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa
import Photos

final class CouponDetailViewController: UIViewController {
    enum Constants {
        static let deviceWidth = UIApplication.shared.width
        static let deviceHeight = UIApplication.shared.height
        static let captureWidth = 375.0
        static let captureHeight = 578.0
        static let capturePositionX = (deviceWidth - captureWidth) / 2
        static let capturePositionY = (deviceHeight - captureHeight) / 2
        static let captureFrame = CGRect(x: capturePositionX, y: capturePositionY, width: captureWidth, height: captureHeight)
        static let backButtonPadding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        
        static let errorLabel = "쿠폰이 존재하지 않아요."
        static let errorCloseButton = "되돌아가기"
        static let rewardLabel = "Reward"
        static let recipientHeaderLabel = "받는 사람"
        static let senderHeaderLabel = "주는 사람"
        static let missionStartDateViewTitle = "미션 시작일"
        static let missionCompletedDateViewTitle = "미션 완료일"
        static let requestGiftButtonTitle = "선물 조르기"
        static let receiveGifitButtonTitle = "선물 받기 완료"
        static let promiseLabel = "까지\n선물을 전달하기로 약속했어요!"
        static let childCompletedGift = "선물 받기 완료"
        static let parentCompletedGift = "선물 전달 완료"
        static let logoLabel = "PolZZak!"
        
        static let success = Toast(type: .success("쿠폰이 사진첩에 저장됐어요"))
    }
    
    private let viewModel: CouponDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var toast: Toast?
    
    private let contentsView: UIView = {
        let view = UIView()
        view.isHidden = true
        return view
    }()
    
    private let fullLoadingView = FullLoadingView()
    
    //MARK: - topView
    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadious(cornerRadius: 12)
        return view
    }()
    
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue200
        return view
    }()
    
    private let topStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        return stackView
    }()
    
    private let topDottedLine = UIView()
    
    private let rewardLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.rewardLabel, textColor: .blue600, font: .subtitle16Sbd)
        return label
    }()
    
    private let couponTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setLabel(textColor: .gray800, font: .subtitle20Sbd)
        return label
    }()
    
    //MARK: - middleView
    private let middleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadious(cornerRadius: 12)
        return view
    }()
    
    private let recipientStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        return stackView
    }()
    
    private let recipientSubStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let recipientHeaderLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.recipientHeaderLabel, textColor: .gray500, font: .body13Md)
        return label
    }()
    
    private let recipientNicknameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .subtitle16Sbd)
        return label
    }()
    
    private let recipientProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfileCharacter
        imageView.contentMode = .scaleAspectFit
        imageView.addCornerRadious(cornerRadius: 22)
        return imageView
    }()
    
    private let senderStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 14
        return stackView
    }()
    
    private let senderSubStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private let senderHeaderLabel: UILabel = {
        let label = UILabel()
        label.setLabel(text: Constants.senderHeaderLabel, textColor: .gray500, font: .body13Md)
        return label
    }()
    
    private let senderNicknameLabel: UILabel = {
        let label = UILabel()
        label.setLabel(textColor: .gray800, font: .subtitle16Sbd)
        return label
    }()
    
    private let senderProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .defaultProfileCharacter
        imageView.contentMode = .scaleAspectFit
        imageView.addCornerRadious(cornerRadius: 22)
        return imageView
    }()
    
    private let missionStatusTopLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray200
        return view
    }()
    
    private let missionStatusView = MissionStatusView()
    
    //MARK: - bottomView
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addCornerRadious(cornerRadius: 12)
        return view
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 30
        return stackView
    }()
    
    private let missionStartDateView: MissionDateView = {
        let missionDateView = MissionDateView()
        missionDateView.setTitle(Constants.missionStartDateViewTitle)
        return missionDateView
    }()
    
    private let missionCompletedDateView: MissionDateView = {
        let missionDateView = MissionDateView()
        missionDateView.setTitle(Constants.missionCompletedDateViewTitle)
        return missionDateView
    }()
    
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue200
        return view
    }()
    
    private let bottomDottedLine = UIView()
    
    //MARK: - footer
    private let footerView = UIView()
    
    private let promiseLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setLabel(textColor: .gray700, font: .body14Sbd, textAlignment: .center)
        label.isHidden = true
        return label
    }()
    
    private let completedGift: PaddedLabel = {
        let label = PaddedLabel(padding: UIEdgeInsets(top: 6, left: 12, bottom: 6, right: 12))
        label.setLabel(textColor: .white, font: .body14Sbd, backgroundColor: .blue600)
        label.addCornerRadious(cornerRadius: 16)
        label.isHidden = true
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .fillEqually
        stackView.isHidden = true
        return stackView
    }()
    
    private let requestGiftButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: Constants.requestGiftButtonTitle, titleColor: .white, font: .subtitle16Sbd, backgroundColor: .blue600)
        button.addCornerRadious(cornerRadius: 8)
        return button
    }()
    
    private let receiveGifitButton: UIButton = {
        let button = UIButton()
        button.setTitleLabel(title: Constants.receiveGifitButtonTitle, titleColor: .blue600, font: .subtitle16Sbd, backgroundColor: .white)
        button.addCornerRadious(cornerRadius: 8)
        return button
    }()
    
    private let captureView = UIView()
    
    //MARK: - init
    init(viewModel: CouponDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegate()
        bindViewModel()
        viewModel.tempAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetNavigation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentsView.layoutIfNeeded()
        addDottedLineToView(topDottedLine, cornerRadius: 12)
        addDottedLineToView(bottomDottedLine, cornerRadius: 12)
    }
}

extension CouponDetailViewController {
    private func setupNavigation() {
        setNavigationBarStyle(backgroundColor: .blue500)
        
        var configuration = UIButton.Configuration.plain()
        let backButtonImage = UIImage(systemName: "chevron.backward")?.withAlignmentRectInsets(Constants.backButtonPadding)
        configuration.image = backButtonImage
        
        let backButton = UIButton(configuration: configuration, primaryAction: UIAction(handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: false)
        }))
        backButton.tintColor = .white
        
        let leftBarButtonItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(image: .pictureButton, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        rightBarButtonItem.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.handleCaptureButtonTap()
            }
            .store(in: &cancellables)
    }
    
    private func resetNavigation() {
        setNavigationBarStyle()
    }
    
    private func setupDelegate() {
        missionStatusView.delegate = self
    }
    
    private func setupUI() {
        view.backgroundColor = .blue500
        
        setupNavigationBar()
        setupLoadingBar()
        setupContentView()
        setupCaptureView()
        setupTopView()
        setupMiddleView()
        setupBottomView()
        setupFooterView()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .blue500
        setNavigationBarStyle(backgroundColor: .blue500)
    }
    
    private func setupLoadingBar() {
        if let navigationController = self.navigationController {
            navigationController.view.addSubview(fullLoadingView)
            fullLoadingView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
    
    private func setupContentView() {
        view.addSubview(contentsView)
        contentsView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(26)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        [captureView, footerView, buttonStackView].forEach {
            contentsView.addSubview($0)
        }
    }
    
    private func setupCaptureView() {
        captureView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        [topView, middleView, bottomView, topDottedLine, bottomDottedLine].forEach {
            captureView.addSubview($0)
        }
    }
    
    private func setupTopView() {
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        [topStackView, topLineView].forEach {
            topView.addSubview($0)
        }
        
        [rewardLabel, couponTitleLabel].forEach {
            topStackView.addArrangedSubview($0)
        }
        
        topStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        topLineView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(6)
        }
    }
    
    private func setupMiddleView() {
        middleView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        [recipientStackView, senderStackView, missionStatusView, missionStatusTopLineView].forEach {
            middleView.addSubview($0)
        }
        
        recipientProfileImageView.snp.makeConstraints {
            $0.height.width.equalTo(44)
        }
        
        [recipientProfileImageView, recipientSubStackView].forEach {
            recipientStackView.addArrangedSubview($0)
        }
        
        [recipientHeaderLabel, recipientNicknameLabel].forEach {
            recipientSubStackView.addArrangedSubview($0)
        }
        
        recipientStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalToSuperview().inset(19)
        }
        
        senderProfileImageView.snp.makeConstraints {
            $0.height.width.equalTo(44)
        }
        
        [senderProfileImageView, senderSubStackView].forEach {
            senderStackView.addArrangedSubview($0)
        }
        
        [senderHeaderLabel, senderNicknameLabel].forEach {
            senderSubStackView.addArrangedSubview($0)
        }
        
        senderStackView.snp.makeConstraints {
            $0.top.equalTo(recipientStackView.snp.bottom).offset(21)
            $0.leading.equalToSuperview().inset(26)
            $0.trailing.equalToSuperview().inset(19)
        }
        
        missionStatusView.snp.makeConstraints {
            $0.top.equalTo(senderStackView.snp.bottom).offset(23)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        missionStatusTopLineView.snp.makeConstraints {
            $0.top.equalTo(missionStatusView.snp.top).offset(-1)
            $0.leading.equalTo(missionStatusView.snp.leading)
            $0.trailing.equalTo(missionStatusView.snp.trailing)
            $0.height.equalTo(2)
        }
    }
    
    private func setupBottomView() {
        bottomView.snp.makeConstraints {
            $0.top.equalTo(middleView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        [bottomStackView, bottomLineView].forEach {
            bottomView.addSubview($0)
        }
        
        [missionStartDateView, missionCompletedDateView].forEach {
            bottomStackView.addArrangedSubview($0)
        }
        
        bottomStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview()
        }
        
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(bottomStackView.snp.bottom).offset(20)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(6)
        }
        
        topDottedLine.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).inset(1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
        
        bottomDottedLine.snp.makeConstraints {
            $0.top.equalTo(middleView.snp.bottom).inset(1)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(2)
        }
    }
    
    private func setupFooterView() {
        footerView.snp.makeConstraints {
            $0.top.equalTo(captureView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        [promiseLabel, completedGift].forEach {
            footerView.addSubview($0)
        }
        
        promiseLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        completedGift.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.centerX.equalToSuperview()
        }
        
        [requestGiftButton, receiveGifitButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(bottomView.snp.width)
            $0.height.equalTo(50)
        }
    }
    
    private func bindViewModel() {
        viewModel.showErrorAlertSubject
            .sink { [weak self] in
                self?.showErrorAlert()
            }
            .store(in: &cancellables)
        
        viewModel.$isCenterLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] bool in
                self?.handleLoadingView(for: bool)
            }
            .store(in: &cancellables)
        
        viewModel.$tabState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleTabState(tabState: state)
            }
            .store(in: &cancellables)
        
        viewModel.$couponDetailData
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] couponData in
                self?.setupNavigation()
                self?.configure(couponData: couponData)
            }
            .store(in: &cancellables)
        
        viewModel.permissionSubject
            .sink { [weak self] in
                self?.requestPhotoLibraryPermission()
            }
            .store(in: &cancellables)
        
        viewModel.photoAccessSubject
            .sink { [weak self] in
                self?.showPhotoAccessAlert()
            }
            .store(in: &cancellables)
        
        viewModel.captureImageSaveSubject
            .sink { [weak self] _ in
                self?.captureAndSaveImage()
            }
            .store(in: &cancellables)
        
        viewModel.showSuccessToastSubject
            .sink { [weak self] _ in
                self?.showToast()
            }
            .store(in: &cancellables)
    }
    
    private func handleLoadingView(for bool: Bool) {
        if true == bool {
            fullLoadingView.startLoading()
        } else {
            fullLoadingView.stopLoading()
        }
    }
    
    private func handleTabState(tabState: TabState) {
        promiseLabel.isHidden = tabState == .completed
        completedGift.isHidden = tabState == .inProgress
        buttonStackView.isHidden = viewModel.userType == .parent
    }
    
    private func addDottedLineToView(_ view: UIView, cornerRadius: CGFloat) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.gray200.cgColor
        shapeLayer.lineWidth = 2
        shapeLayer.lineDashPattern = [12, 10]
        shapeLayer.lineCap = .round
        
        let path = UIBezierPath()
        let startPoint = CGPoint(x: cornerRadius, y: view.bounds.height - 1)
        let endPoint = CGPoint(x: view.bounds.width - cornerRadius, y: view.bounds.height - 1)
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        shapeLayer.path = path.cgPath
        
        view.layer.addSublayer(shapeLayer)
    }
    
    private func configure(couponData: CouponDetail) {
        contentsView.isHidden = false
        couponTitleLabel.text = couponData.reward
        recipientNicknameLabel.text = couponData.kid.nickname
        recipientProfileImageView.loadImage(from: couponData.kid.profileURL)
        senderNicknameLabel.text = couponData.guardian.nickname
        senderProfileImageView.loadImage(from: couponData.guardian.profileURL)
        
        let startDate = couponData.startDate
        let endDate = couponData.endDate
        let duration = endDate.daysDifference(from: startDate)
        missionStatusView.configure(completedMission: couponData.missionContents.count, completedStamp: couponData.stampCount, duration: duration)
        missionStartDateView.configure(date: startDate.longDateFormat())
        missionCompletedDateView.configure(date: endDate.longDateFormat())
        
        switch viewModel.tabState {
        case .inProgress:
            //TODO: - 서버에서 필드 추가해야함
            let tempDate = "2023-08-13T13:08:25.030623693".longDateFormat()
            promiseLabel.text = "\(tempDate)" + Constants.promiseLabel
            let emphasisRange = [NSRange(location: 0, length: tempDate.count)]
            promiseLabel.setEmphasisRanges(emphasisRange, color: .white, font: .body14Sbd)
        case .completed:
            completedGift.text = (viewModel.userType == .parent) ? Constants.parentCompletedGift : Constants.childCompletedGift
        }
    }
    
    private func showErrorAlert() {
        let alertView = AlertButtonView(buttonStyle: .single)
        alertView.contentLabel.setLabel(text: Constants.errorLabel, textColor: .gray700, font: .subtitle18Sbd)
        alertView.closeButton.text = Constants.errorCloseButton
        alertView.firstButtonAction = {
            self.navigationController?.popViewController(animated: false)
        }
        navigationController?.present(alertView, animated: false)
    }
    
    private func showPhotoAccessAlert() {
        let accessAlert = PhotoAccessAlertController()
        navigationController?.present(accessAlert, animated: false)
    }
    
    private func captureAndSaveImage() {
        let capturedImage = prepareImageForCapture()
        if let image = capturedImage {
            viewModel.processCapturedImage(image)
        }
    }
    
    private func prepareImageForCapture() -> UIImage? {
        let tempImageView = UIView(frame: Constants.captureFrame)
        
        let captureBackgroundView = UIView()
        captureBackgroundView.backgroundColor = .blue500
        tempImageView.addSubview(captureBackgroundView)
        
        let captureImageView = UIImageView(image: captureView.capture())
        captureBackgroundView.addSubview(captureImageView)
        captureImageView.contentMode = .scaleAspectFit
        
        captureImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40)
            $0.leading.trailing.equalToSuperview().inset(26)
        }
        
        let logoLabel = UILabel()
        logoLabel.setLabel(text: Constants.logoLabel, textColor: .white.withAlphaComponent(0.5), font: .title20Xbd)
        tempImageView.addSubview(logoLabel)
        
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(captureImageView.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
        
        captureBackgroundView.snp.makeConstraints {
            $0.top.equalTo(captureImageView.snp.top).offset(-40)
            $0.leading.equalTo(captureImageView.snp.leading).inset(-26)
            $0.trailing.equalTo(captureImageView.snp.trailing).inset(-26)
            $0.bottom.equalTo(logoLabel.snp.bottom).inset(-30)
        }
        
        tempImageView.layoutIfNeeded()
        
        return tempImageView.capture()
    }
    
    //TODO: - 임시코드, 메인에서 권한체크하면 제거할 예정
    private func requestPhotoLibraryPermission() {
        PHPhotoLibrary.requestAuthorization { _ in }
    }
    
    private func showToast() {
        toast = Constants.success
        toast?.show()
    }
}

extension CouponDetailViewController: MissionStatusViewDelegate {
    func didTapMissionHeader() {
        guard let missions = viewModel.couponDetailData?.missionContents else {
            return
        }
        
        let missionListView = AlertTableViewController()
        missionListView.configure(data: missions)
        navigationController?.present(missionListView, animated: false)
    }
}
