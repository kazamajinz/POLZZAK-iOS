//
//  MainViewModel.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/23.
//

import UIKit
import Combine

final class MainViewModel {
    //TODO: - 임시
    @Published var userType: UserType = .child
    
    @Published var isSkeleton: Bool = true
    @Published var isCenterLoading: Bool = false
    @Published var stampBoardListData: [UserStampBoardList] = []
    @Published var tabState: TabState = .inProgress
    @Published var filterType: FilterType = .all
    
    @Published var apiFinishedLoadingSubject: Bool = false
    @Published var didEndDraggingSubject: Bool = false
    
    func tempInprogressAPI(for centerLoading: Bool = false, isFirst: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading && false == isFirst {
                self.apiFinishedLoadingSubject = true
            }
            
            if isSkeleton == true {
                self.hideSkeletonView()
            } else {
                self.hideLoading(for: centerLoading)
            }
            
            self.stampBoardListData = UserStampBoardList.sampleData
        }
    }
    
    func tempCompletedAPI(for centerLoading: Bool = false) {
        showLoading(for: centerLoading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            if false == centerLoading {
                self.apiFinishedLoadingSubject = true
            }
            self.hideLoading(for: centerLoading)
            self.stampBoardListData = UserStampBoardList.sampleData3
        }
    }
    
    func indexOfMember(with memberId: Int) -> Int {
        return stampBoardListData.firstIndex { $0.familyMember.memberId == memberId } ?? 0
    }
    
    func preGiftTabSelected() {
        if tabState != .inProgress {
            tabState = .inProgress
        }
    }
    
    func postGiftTabSelected() {
        if tabState != .completed {
            tabState = .completed
        }
    }
    
    private func hideSkeletonView() {
        isSkeleton = false
    }
    
    private func showLoading(for centerLoading: Bool) {
        if centerLoading == true {
            isCenterLoading = true
        }
    }
    
    private func hideLoading(for centerLoading: Bool) {
        if centerLoading == true {
            isCenterLoading = false
        }
    }
    
    func resetSubjects() {
        apiFinishedLoadingSubject = false
        didEndDraggingSubject = false
    }
    
    func refreshData() {
        switch tabState {
        case .inProgress:
            tempInprogressAPI()
        case .completed:
            tempCompletedAPI()
        }
    }
}
