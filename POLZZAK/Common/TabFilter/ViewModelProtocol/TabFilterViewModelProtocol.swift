//
//  TabFilterViewModelProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/26.
//

import Foundation
import Combine

protocol TabFilterViewModelProtocol: AnyObject {
    var cancellables: Set<AnyCancellable> { get set }
    var tabState: CurrentValueSubject<TabState, Never> { get }
    var filterType: CurrentValueSubject<FilterType, Never> { get }
    
    func setInProgressTab()
    func setCompletedTab()
}

extension TabFilterViewModelProtocol {
    func setInProgressTab() {
        tabState.send(.inProgress)
    }
    
    func setCompletedTab() {
        tabState.send(.completed)
    }
}

