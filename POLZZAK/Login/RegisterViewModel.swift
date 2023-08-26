//
//  RegisterViewModel.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/22.
//

import Combine
import Foundation
import UIKit

final class RegisterViewModel {
    enum Input {
        case register
    }
    
    enum Output {
        
    }
    
    struct State {
        var memberType: Int?
        var nickname: String?
        var profileImage: UIImage?
    }
    
    let input = PassthroughSubject<Input, Never>()
    var state: State
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.state = State()
    }
    
    private func bind() {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .register:
                requestRegister()
            }
        }
        .store(in: &cancellables)
    }
    
    private func requestRegister() {
        guard let memberType = state.memberType, let nickname = state.nickname else { return }
        
    }
    
    deinit {
        print("RegisterViewModel deinit")
    }
}
