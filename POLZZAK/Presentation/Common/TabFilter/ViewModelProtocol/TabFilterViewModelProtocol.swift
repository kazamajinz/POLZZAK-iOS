//
//  TabFilterViewModelProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/26.
//

import Foundation
import Combine

protocol TabFilterViewModelProtocol: AnyObject {
    associatedtype DataListType
    
    var userType: UserType { get set }
    var dataList: CurrentValueSubject<[DataListType], Never> { get set }
    var cancellables: Set<AnyCancellable> { get set }
    var tabState: CurrentValueSubject<TabState, Never> { get }
    var filterType: CurrentValueSubject<FilterType, Never> { get }
    
    func setInProgressTab()
    func setCompletedTab()
    func loadData(for: Bool)
}

extension TabFilterViewModelProtocol {
    func setInProgressTab() {
        tabState.send(.inProgress)
    }
    
    func setCompletedTab() {
        tabState.send(.completed)
    }
    
    func setupTabFilterBindings() {
        tabState
            .removeDuplicates()
            .sink { [weak self] tabState in
                self?.loadData(for: true)
            }
            .store(in: &cancellables)
    }
}

