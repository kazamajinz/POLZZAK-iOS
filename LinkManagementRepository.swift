// MARK: - Mocks generated from file: POLZZAK/DomainLayer/Repositories/LinkManagementRepository.swift at 2023-09-18 10:40:16 +0000

//
//  LinkManagementRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockLinkManagementRepository: LinkManagementRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = LinkManagementRepository
    
     typealias Stubbing = __StubbingProxy_LinkManagementRepository
     typealias Verification = __VerificationProxy_LinkManagementRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: LinkManagementRepository?

     func enableDefaultImplementation(_ stub: LinkManagementRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getUserByNickname(_ nickname: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    getUserByNickname(_: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError>
    """,
            parameters: (nickname),
            escapingParameters: (nickname),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getUserByNickname(nickname))
        
    }
    
    
    
    
    
     func getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getLinkedUsers())
        
    }
    
    
    
    
    
     func getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getReceivedLinkRequests())
        
    }
    
    
    
    
    
     func getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getSentLinkRequests())
        
    }
    
    
    
    
    
     func createLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    createLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.createLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     func deleteSentLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    deleteSentLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.deleteSentLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    approveLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.approveLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    rejectLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.rejectLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     func removeLink(with memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    removeLink(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.removeLink(with: memberID))
        
    }
    
    
    
    
    
     func checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.checkNewLinkRequest())
        
    }
    
    

     struct __StubbingProxy_LinkManagementRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getUserByNickname<M1: Cuckoo.Matchable>(_ nickname: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), NetworkResult<BaseResponse<FamilyMember>, NetworkError>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nickname) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    getUserByNickname(_: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getLinkedUsers() -> Cuckoo.ProtocolStubThrowingFunction<(), NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getReceivedLinkRequests() -> Cuckoo.ProtocolStubThrowingFunction<(), NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getSentLinkRequests() -> Cuckoo.ProtocolStubThrowingFunction<(), NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func createLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    createLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func deleteSentLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    deleteSentLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func approveLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    approveLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rejectLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    rejectLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeLink<M1: Cuckoo.Matchable>(with memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    removeLink(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func checkNewLinkRequest() -> Cuckoo.ProtocolStubThrowingFunction<(), NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementRepository.self, method:
    """
    checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_LinkManagementRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getUserByNickname<M1: Cuckoo.Matchable>(_ nickname: M1) -> Cuckoo.__DoNotUse<(String), NetworkResult<BaseResponse<FamilyMember>, NetworkError>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nickname) { $0 }]
            return cuckoo_manager.verify(
    """
    getUserByNickname(_: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getLinkedUsers() -> Cuckoo.__DoNotUse<(), NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getReceivedLinkRequests() -> Cuckoo.__DoNotUse<(), NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getSentLinkRequests() -> Cuckoo.__DoNotUse<(), NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func createLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    createLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func deleteSentLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    deleteSentLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func approveLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    approveLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func rejectLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    rejectLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func removeLink<M1: Cuckoo.Matchable>(with memberID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    removeLink(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func checkNewLinkRequest() -> Cuckoo.__DoNotUse<(), NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class LinkManagementRepositoryStub: LinkManagementRepository {
    

    

    
    
    
    
     func getUserByNickname(_ nickname: String) async throws -> NetworkResult<BaseResponse<FamilyMember>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<FamilyMember>, NetworkError>).self)
    }
    
    
    
    
    
     func getLinkedUsers() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>).self)
    }
    
    
    
    
    
     func getReceivedLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>).self)
    }
    
    
    
    
    
     func getSentLinkRequests() async throws -> NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<[FamilyMember]>, NetworkError>).self)
    }
    
    
    
    
    
     func createLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>).self)
    }
    
    
    
    
    
     func deleteSentLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
    
    
    
     func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
    
    
    
     func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
    
    
    
     func removeLink(with memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
    
    
    
     func checkNewLinkRequest() async throws -> NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<CheckLinkRequest>, NetworkError>).self)
    }
    
    
}




