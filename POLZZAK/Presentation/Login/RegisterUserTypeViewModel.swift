//
//  RegisterUserTypeViewModel.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/22.
//

import Combine
import Foundation

final class RegisterUserTypeViewModel {
    enum Input {
        case getMemberTypes
        case nextButtonTapped
        case userTypeButtonTapped(LoginUserType)
    }
    
    final class State {
        @Published fileprivate(set) var isLoading = false
    }
    
    let registerModel: RegisterModel
    let input = PassthroughSubject<Input, Never>()
    let state: State = .init()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(registerModel: RegisterModel) {
        self.registerModel = registerModel
        bind()
    }
    
    private func bind() {
        input.sink { [weak self] input in
            guard let self else { return }
            switch input {
            case .getMemberTypes:
                requestMemberTypes()
            case .nextButtonTapped:
                registerModel.setMemberTypeAndList()
            case .userTypeButtonTapped(let userType):
                registerModel.chosenUserType = userType
            }
        }
        .store(in: &cancellables)
    }
    
    private func requestMemberTypes() {
        state.isLoading = true
        Task { [weak self] in
            defer {
                state.isLoading = false
            }
            
            guard let self else { return }
            guard let (data, response) = try? await MemberTypeAPI.getMemberTypes() else { return }
            guard let httpResponse = response as? HTTPURLResponse else { return }
            let statusCode = httpResponse.statusCode
            
            switch statusCode {
            case 200..<300:
                let dto = try JSONDecoder().decode(BaseResponseDTO<MemberTypeDetailListDTO>.self, from: data)
                guard let memberTypeDetailList = dto.data?.memberTypeDetailList else { return }
                registerModel.fetchedMemberTypeDetailList = memberTypeDetailList
                print(memberTypeDetailList)
            default:
                print("statusCode: ", statusCode)
                let dto = try? JSONDecoder().decode(BaseResponseDTO<String>.self, from: data)
                guard let messages = dto?.messages else { return }
                print(messages)
            }
        }
    }
}
