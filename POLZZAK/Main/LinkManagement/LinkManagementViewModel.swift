//
//  LinkManagementViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/29.
//

import Foundation
import Combine

final class LinkManagementViewModel {
    @Published var dataList: [FamilyMember] = []
    @Published var isTabLoading: Bool = true
    @Published var linkTabState: LinkTabState = .unknwon
    
    //TODO: - 3가지 API가 필요
    func tempAPI() {
        showLoading()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.dataList = FamilyData.sampleData.families
            hideLoading()
        }
    }
    
    func handleTabLoading(for isLoading: Bool) {
        if false == isLoading {
            hideLoading()
        } else {
            showLoading()
        }
    }
    
    func showLoading() {
        isTabLoading = true
    }
    
    func hideLoading() {
        isTabLoading = false
    }
    
    func linkListTabTapped() {
        linkTabState = .linkListTab
    }
    
    func receivedTabTapped() {
        linkTabState = .receivedTab
    }
    
    func sentTabTapped() {
        linkTabState = .sentTab
    }
}
