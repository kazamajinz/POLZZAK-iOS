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
    
    private let repository: CouponRepository
    
    private let couponID: Int
    
    var userType: UserType
    @Published var isCenterLoading: Bool = true
    @Published var couponDetailData: CouponDetail? = nil
    private var timer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()
    
    
    var showSuccessToastSubject = PassthroughSubject<Void, Never>()
    var permissionSubject = PassthroughSubject<Void, Never>()
    var photoAccessSubject = PassthroughSubject<Void, Never>()
    var captureImageSaveSubject = PassthroughSubject<Void, Never>()
    var requestGiftSubject = PassthroughSubject<Void, Never>()
    var receiveGiftSubject = PassthroughSubject<Void, Never>()
    var remainingTimeSubject = PassthroughSubject<String?, Never>()
    var showErrorAlertSubject = PassthroughSubject<Error, Never>()
    
    init(repository: CouponRepository, couponID: Int) {
        self.repository = repository
        self.couponID = couponID
        
        //TODO: - DTO에서 Model로 변환할때 UserType을 단순하게 부모인지 아이인지 변환하고 UserInfo에서 사용하는 Model에 userType을 추가했으면 좋겠음.
        let userInfo = UserInfoManager.readUserInfo()
        userType = (userInfo?.memberType.detail == "아이" ? .child : .parent)
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
    
    func fetchCouponDetail() {
        Task {
            do {
                let result = try await repository.getCouponDetail(with: couponID)
                couponDetailData = result
                
                if let time = result?.rewardRequestDate {
                    startTimer(for: time)
                }
            } catch {
                handleError(error)
            }
            hideLoading()
        }
    }
    
    func sendGiftRequest() async {
        do {
            try await repository.createGiftRequest(with: couponID)
            requestGiftSubject.send()
            let nowTime = Date().toString()
            startTimer(for: nowTime)
        } catch {
            handleError(error)
        }
    }
    
    func sendGiftReceive() async {
        do {
            try await repository.sendGiftReceive(from: couponID)
            couponDetailData?.couponState = .rewarded
        } catch {
            handleError(error)
        }
    }
    
    private func startTimer(for targetTime: String) {
        updateRemainingTime(for: targetTime)
        
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.updateRemainingTime(for: targetTime)
            }
    }
    
    private func updateRemainingTime(for targetTime: String) {
        if let remainingTime = targetTime.remainingHourTime() {
            remainingTimeSubject.send(remainingTime)
        } else {
            remainingTimeSubject.send(nil)
            timer?.cancel()
        }
    }
    
    private func showLoading() {
        isCenterLoading = true
    }
    
    private func hideLoading() {
        isCenterLoading = false
    }
    
    func handleError(_ error: Error) {
        if let internalError = error as? PolzzakError {
            handleInternalError(internalError)
        } else if let networkError = error as? NetworkError {
            handleNetworkError(networkError)
        } else if let decodingError = error as? DecodingError {
            handleDecodingError(decodingError)
        } else {
            handleUnknownError(error)
        }
    }
    
    private func handleInternalError(_ error: PolzzakError) {
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
