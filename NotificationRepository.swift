// MARK: - Mocks generated from file: POLZZAK/DomainLayer/Repositories/NotificationRepository.swift at 2023-09-18 10:40:16 +0000

//
//  NotificationRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockNotificationRepository: NotificationRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = NotificationRepository
    
     typealias Stubbing = __StubbingProxy_NotificationRepository
     typealias Verification = __VerificationProxy_NotificationRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: NotificationRepository?

     func enableDefaultImplementation(_ stub: NotificationRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fetchNotificationList(with startID: Int?) async throws -> NetworkResult<BaseResponse<NotificationResponse>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchNotificationList(with: Int?) async throws -> NetworkResult<BaseResponse<NotificationResponse>, NetworkError>
    """,
            parameters: (startID),
            escapingParameters: (startID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.fetchNotificationList(with: startID))
        
    }
    
    
    
    
    
     func removeNotification(with notificationID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    removeNotification(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """,
            parameters: (notificationID),
            escapingParameters: (notificationID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.removeNotification(with: notificationID))
        
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
    
    

     struct __StubbingProxy_NotificationRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fetchNotificationList<M1: Cuckoo.OptionalMatchable>(with startID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int?), NetworkResult<BaseResponse<NotificationResponse>, NetworkError>> where M1.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int?)>] = [wrap(matchable: startID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNotificationRepository.self, method:
    """
    fetchNotificationList(with: Int?) async throws -> NetworkResult<BaseResponse<NotificationResponse>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func removeNotification<M1: Cuckoo.Matchable>(with notificationID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: notificationID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNotificationRepository.self, method:
    """
    removeNotification(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func approveLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNotificationRepository.self, method:
    """
    approveLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rejectLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNotificationRepository.self, method:
    """
    rejectLinkRequest(to: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_NotificationRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fetchNotificationList<M1: Cuckoo.OptionalMatchable>(with startID: M1) -> Cuckoo.__DoNotUse<(Int?), NetworkResult<BaseResponse<NotificationResponse>, NetworkError>> where M1.OptionalMatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int?)>] = [wrap(matchable: startID) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchNotificationList(with: Int?) async throws -> NetworkResult<BaseResponse<NotificationResponse>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func removeNotification<M1: Cuckoo.Matchable>(with notificationID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: notificationID) { $0 }]
            return cuckoo_manager.verify(
    """
    removeNotification(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
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
        
        
    }
}


 class NotificationRepositoryStub: NotificationRepository {
    

    

    
    
    
    
     func fetchNotificationList(with startID: Int?) async throws -> NetworkResult<BaseResponse<NotificationResponse>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<NotificationResponse>, NetworkError>).self)
    }
    
    
    
    
    
     func removeNotification(with notificationID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
    
    
    
     func approveLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
    
    
    
     func rejectLinkRequest(to memberID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
}




