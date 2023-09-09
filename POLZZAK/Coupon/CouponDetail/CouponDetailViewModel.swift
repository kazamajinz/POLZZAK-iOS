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
    
    private let useCase: CouponsUsecase
    
    private let couponID: Int
    
    //TODO: - 임시
    let userType: UserType = .child
    
    @Published var tabState: TabState
    @Published var isCenterLoading: Bool = true
    @Published var couponDetailData: CouponDetail? = nil
    
    let showSuccessToastSubject = PassthroughSubject<Void, Never>()
    let permissionSubject = PassthroughSubject<Void, Never>()
    let photoAccessSubject = PassthroughSubject<Void, Never>()
    let captureImageSaveSubject = PassthroughSubject<Void, Never>()
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    
    init(useCase: CouponsUsecase, tabState: TabState, couponID: Int) {
        self.useCase = useCase
        self.tabState = tabState
        self.couponID = couponID
    }
    
    func tempAPI() {
        Task {
            do {
                let task = useCase.fetchCouponDetail(with: couponID)
                let result = try await task.value
                couponDetailData = result
            } catch {
                handleError(error)
            }
            hideLoading()
        }
    }
    
    private func showLoading() {
        isCenterLoading = true
    }
    
    private func hideLoading() {
        isCenterLoading = false
    }
    
    func handleError(_ error: Error) {
        if let internalError = error as? PolzzakError<Void> {
            handleInternalError(internalError)
        } else if let networkError = error as? NetworkError {
            handleNetworkError(networkError)
        } else if let decodingError = error as? DecodingError {
            handleDecodingError(decodingError)
        } else {
            handleUnknownError(error)
        }
    }
    
    private func handleInternalError(_ error: PolzzakError<Void>) {
        showErrorAlertSubject.send(error)
    }
    
    private func handleNetworkError(_ error: NetworkError) {
        showErrorAlertSubject.send(error)
    }
    
    private func handleDecodingError(_ error: DecodingError) {
        showErrorAlertSubject.send(error)
    }
    
    private func handleUnknownError(_ error: Error) {
        showErrorAlertSubject.send(error)
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
