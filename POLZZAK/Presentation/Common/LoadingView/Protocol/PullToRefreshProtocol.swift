//
//  PullToRefreshProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation
import Combine

protocol PullToRefreshProtocol: AnyObject {
    var apiFinishedLoadingSubject: CurrentValueSubject<Bool, Never> { get }
    var didEndDraggingSubject: PassthroughSubject<Void, Never> { get }
    var shouldEndRefreshing: PassthroughSubject<Bool, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    func setupPullToRefreshBinding()
    func resetPullToRefreshSubjects()
}

extension PullToRefreshProtocol {
    func setupPullToRefreshBinding() {
        apiFinishedLoadingSubject.combineLatest(didEndDraggingSubject)
            .map { apiFinished, _ -> Bool in
                return apiFinished
            }
            .filter { $0 }
            .sink { [weak self] apiFinished in
                self?.shouldEndRefreshing.send(!apiFinished)
            }
            .store(in: &cancellables)
    }
    
    func resetPullToRefreshSubjects() {
        self.apiFinishedLoadingSubject.send(false)
    }
}
