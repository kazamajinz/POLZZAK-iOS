//
//  InitialLoadingViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/17.
//

import UIKit

import SnapKit

final class InitialLoadingViewController: UIViewController {
    private let fullScreenLoadingView = FullScreenLoadingView() // TODO: 추후 변경
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureLayout()
        getUserInfo()
    }
    
    private func configureView() {
        view.backgroundColor = .gray100
    }
    
    private func configureLayout() {
        view.addSubview(fullScreenLoadingView)
        
        fullScreenLoadingView.topSpacing = 350
        
        fullScreenLoadingView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func getUserInfo() {
        fullScreenLoadingView.startLoading()
        Task { [weak self] in
            let result = try? await UserAPI.getUserInfo()
            self?.handleUserInfoResult(result: result)
        }
    }
    
    private func handleUserInfoResult(result: (Data, URLResponse)?) {
        guard let (data, response) = result else { return }
        guard let httpResponse = response as? HTTPURLResponse else { return }
        let statusCode = httpResponse.statusCode
        
        switch statusCode {
        case 200..<300:
            let dto = try? JSONDecoder().decode(UserInfoDTO.self, from: data)
            guard let data = dto?.data else { return }
            UserInfoManager.saveUserInfo(data)
            AppFlowController.shared.showHome()
        default: // TODO: 네트워크 연결이 끊겼을 경우 여기를 탈 것으로 예상되는데 그 떄는 로그인 화면으로 가면 안 될듯.. 처리 필요할듯
            UserInfoManager.deleteToken(type: .access)
            UserInfoManager.deleteToken(type: .refresh)
            AppFlowController.shared.showLogin()
        }
        
        fullScreenLoadingView.stopLoading()
    }
}
