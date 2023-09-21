//
//  StampAllowBottomSheetViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/30.
//

import Combine
import UIKit

import CombineCocoa
import PanModal

final class StampAllowBottomSheetViewController: StampBasicBottomSheetViewController {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: getLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureBinding()
    }
    
    private func configureView() {
        setTitleLabel(text: "미션 직접 선택")
        setStepLabel(text: "1/2")
        setRightButton(text: "다음")
        setLeftButton(text: "닫기")
        setContentView(view: collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsSelection = false
        collectionView.register(StampAllowCell.self, forCellWithReuseIdentifier: StampAllowCell.reuseIdentifier)
    }
    
    private func configureBinding() {
        setRightButtonTapAction { [weak self] in
            let vc = StampChoiceBottomSheetViewController()
            self?.navigationController?.pushViewController(vc, animated: false)
        }
        
        setLeftButtonTapAction { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - PanModalPresentable
    
    override var panScrollable: UIScrollView? {
        return nil
    }
    
    override var longFormHeight: PanModalHeight {
        return .contentHeight(UIApplication.shared.height * 0.8)
    }
}

// MARK: - UICollectionViewDataSource

extension StampAllowBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StampAllowCell.reuseIdentifier, for: indexPath) as? StampAllowCell else {
            fatalError("StampAllowCell dequeue failed")
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension StampAllowBottomSheetViewController: UICollectionViewDelegate {
    
}

// MARK: - Layout

extension StampAllowBottomSheetViewController {
    static func getLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        return UICollectionViewCompositionalLayout.list(using: config)
    }
}
