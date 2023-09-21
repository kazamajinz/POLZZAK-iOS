//
//  StampChoiceBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/30.
//

import Combine
import UIKit

import CombineCocoa
import PanModal

final class StampChoiceBottomSheetViewController: StampBasicBottomSheetViewController {
    enum Constants {
        static let imageViewHeight: CGFloat = 121
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let contentView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Constants.imageViewHeight / 2
        imageView.backgroundColor = .gray200
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .subtitle16Sbd
        label.textColor = .gray800
        label.text = "참 잘했어요"
        return label
    }()
    
    private let stampSelectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getStampSelectionViewLayout())
        collectionView.register(StampSelectionCell.self, forCellWithReuseIdentifier: StampSelectionCell.reuseIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()
    
    var stampDesignImage: [UIImage] = [UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!, UIImage(named: "select_profile_image1")!]
    
    @Published private var currentStampDesignImage: UIImage?
    
    private var isInitialLoading = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureStampSelectionView()
        configureLayout()
        configureBinding()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isInitialLoading {
            setUICenter()
            isInitialLoading = false
        }
    }
    
    private func configureView() {
        setTitleLabel(text: "도장 선택")
        setStepLabel(text: "2/2")
        setRightButton(text: "도장 찍기")
        setLeftButton(text: "이전")
    }
    
    private func configureLayout() {
        let wrapperView = UIView()
        
        [imageView, titleLabel, stampSelectionView].forEach {
            wrapperView.addSubview($0)
        }
        
        contentView.addSubview(wrapperView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.width.equalTo(Constants.imageViewHeight)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        stampSelectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.height.equalTo(64)
            make.width.equalTo(contentView)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        wrapperView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        setContentView(view: contentView)
    }
    
    private func configureStampSelectionView() {
        stampSelectionView.dataSource = self
        stampSelectionView.delegate = self
    }
    
    private func configureBinding() {
        setRightButtonTapAction { [weak self] in
            self?.dismiss(animated: true)
        }
        
        setLeftButtonTapAction { [weak self] in
            self?.navigationController?.popViewController(animated: false)
        }
        
        $currentStampDesignImage.sink { [weak self] image in
            self?.imageView.image = image
        }
        .store(in: &cancellables)
    }
    
    // MARK: - PanModalPresentable
    
    override var panScrollable: UIScrollView? {
        return nil
    }
    
    override var longFormHeight: PanModalHeight {
        return .contentHeight(UIApplication.shared.height * 0.6)
    }
}

// MARK: - UICollectionViewDataSource

extension StampChoiceBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stampDesignImage.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampSelectionCell.reuseIdentifier, for: indexPath) as? StampSelectionCell else {
            fatalError("Couldn't dequeue StampSelectionCell")
        }
        let image = stampDesignImage[indexPath.item]
        cell.configure(image: image)
        return cell
    }
}

// MARK: - UICollectionViewDelegate & Related

extension StampChoiceBottomSheetViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        processCellUI()
        configureCurrentType()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    private func processCellUI() {
        guard let centerIndexPath = (stampSelectionView.collectionViewLayout as? CarouselLayout)?.centerIndexPath,
              let cell = stampSelectionView.cellForItem(at: centerIndexPath) as? StampSelectionCell
        else { return }
        
        stampSelectionView.visibleCells
            .compactMap { $0 as? StampSelectionCell }
            .forEach {
                $0.unEmphasizeCell()
            }
        
        cell.emphasizeCell()
    }
    
    private func configureCurrentType() {
        guard let layout = stampSelectionView.collectionViewLayout as? CarouselLayout,
              let centerIndexPath = layout.centerIndexPath
        else { return }
        
        currentStampDesignImage = stampDesignImage[centerIndexPath.item]
    }
    
    private func setUICenter() {
        guard let layout = stampSelectionView.collectionViewLayout as? CarouselLayout,
              stampDesignImage.count > 0
        else { return }
        
        let indexToScroll = stampDesignImage.count / 2
        
        DispatchQueue.main.async {
            UIView.performWithoutAnimation {
                let indexPath = IndexPath(item: indexToScroll, section: 0)
                self.stampSelectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                layout.invalidateLayout()
                self.stampSelectionView.layoutIfNeeded()
                self.configureCurrentType()
                guard let cell = self.stampSelectionView.cellForItem(at: indexPath) as? StampSelectionCell else { return }
                cell.emphasizeCell()
            }
        }
    }
}

// MARK: - Layout

extension StampChoiceBottomSheetViewController {
    static func getStampSelectionViewLayout() -> UICollectionViewLayout {
        let layout = CarouselLayout(scrollDirection: .horizontal)
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.spacing = 10
        layout.sideItemScale = 0.8
        layout.sideItemAlpha = 1
        layout.sideItemCount = 2
        return layout
    }
}
