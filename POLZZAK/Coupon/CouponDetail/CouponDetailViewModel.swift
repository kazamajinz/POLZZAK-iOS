//
//  CouponDetailViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/18.
//

import UIKit
import Photos
import Combine

final class CouponDetailViewModel {
    enum SaveResult {
        case success
        case failure(Error)
    }
    
    private let couponID: Int
    
    //TODO: - 임시
    let userType: UserType = .child
    
    @Published var tabState: TabState
    @Published var isCenterLoading: Bool = true
    @Published var couponDetailData: CouponDetail? = nil
    
    let showErrorAlertSubject = PassthroughSubject<Void, Never>()
    let showSuccessToastSubject = PassthroughSubject<Void, Never>()
    let permissionSubject = PassthroughSubject<Void, Never>()
    let photoAccessSubject = PassthroughSubject<Void, Never>()
    let captureImageSaveSubject = PassthroughSubject<Void, Never>()
    
    
    init(tabState: TabState, couponID: Int) {
        self.tabState = tabState
        self.couponID = couponID
    }
    
    func tempAPI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.couponDetailData = CouponDetail.sampleDatas[self.couponID]!
            self.hideLoading()
        }
    }
    
    private func showLoading() {
        isCenterLoading = true
    }
    
    private func hideLoading() {
        isCenterLoading = false
    }
    
    func handleError() {
        showErrorAlertSubject.send()
    }
}

extension CouponDetailViewModel {
    func handleCaptureButtonTap() {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        switch status {
        case .notDetermined:
            permissionSubject.send()
        case .authorized:
            captureImageSaveSubject.send()
        case .denied:
            photoAccessSubject.send()
        default:
            return
        }
    }
    
    func processCapturedImage(_ image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        showSuccessToastSubject.send()
    }
}
