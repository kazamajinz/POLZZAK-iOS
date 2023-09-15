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
    var didEndDraggingSubject: CurrentValueSubject<Bool, Never> { get }
    var shouldEndRefreshing: PassthroughSubject<Void, Never> { get }
    var cancellables: Set<AnyCancellable> { get set }
    func setupPullToRefreshBinding()
    func resetPullToRefreshSubjects()
}

extension PullToRefreshProtocol {
    func setupPullToRefreshBinding() {
        Publishers.CombineLatest(apiFinishedLoadingSubject, didEndDraggingSubject)
            .filter { $0 && !$1 }
            .sink { [weak self] _, _ in
                self?.shouldEndRefreshing.send()
            }
            .store(in: &cancellables)
    }
    
    func resetPullToRefreshSubjects() {
        self.apiFinishedLoadingSubject.send(false)
        self.didEndDraggingSubject.send(true)
    }
}
