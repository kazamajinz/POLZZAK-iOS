//
//  TabFilterLoadingViewModelProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/27.
//

import Foundation
import Combine

protocol TabFilterLoadingViewModelProtocol: TabFilterViewModelProtocol, LoadingViewModelProtocol {
    associatedtype DataListType
    
    var userType: CurrentValueSubject<UserType, Never> { get set }
    var dataList: CurrentValueSubject<[DataListType], Never> { get set }
    
    var apiFinishedLoadingSubject: CurrentValueSubject<Bool, Never> { get }
    var didEndDraggingSubject: CurrentValueSubject<Bool, Never> { get }
    var shouldEndRefreshing: PassthroughSubject<Void, Never> { get }
    
    func setupBindings()
    func resetSubjects()
    func loadData(for: Bool)
}

extension TabFilterLoadingViewModelProtocol {
    func setupBindings() {
        Publishers.CombineLatest(apiFinishedLoadingSubject, didEndDraggingSubject)
            .filter { $0 && $1 }
            .sink { [weak self] (_, _) in
                self?.shouldEndRefreshing.send()
                self?.resetSubjects()
            }
            .store(in: &cancellables)
        
        tabState
            .removeDuplicates()
            .sink { [weak self] tabState in
                self?.loadData(for: true)
            }
            .store(in: &cancellables)
    }
    
    func resetSubjects() {
        self.apiFinishedLoadingSubject.send(false)
        self.didEndDraggingSubject.send(false)
    }
}
