// MARK: - Mocks generated from file: POLZZAK/DataLayer/Network/Services/LinkManagementService.swift at 2023-09-21 08:25:55 +0000

//
//  LinkManagementService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockLinkManagementService: LinkManagementService, Cuckoo.ProtocolMock {
    
     typealias MocksType = LinkManagementService
    
     typealias Stubbing = __StubbingProxy_LinkManagementService
     typealias Verification = __VerificationProxy_LinkManagementService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: LinkManagementService?

     func enableDefaultImplementation(_ stub: LinkManagementService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fetchUserByNickname(_ nickname: String) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchUserByNickname(_: String) async throws -> (Data, URLResponse)
    """,
            parameters: (nickname),
            escapingParameters: (nickname),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.fetchUserByNickname(nickname))
        
    }
    
    
    
    
    
     func fetchAllLinkedUsers() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchAllLinkedUsers() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.fetchAllLinkedUsers())
        
    }
    
    
    
    
    
     func fetchAllReceivedUsers() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchAllReceivedUsers() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.fetchAllReceivedUsers())
        
    }
    
    
    
    
    
     func fetchAllRequestUsers() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchAllRequestUsers() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.fetchAllRequestUsers())
        
    }
    
    
    
    
    
     func sendLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    sendLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sendLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     func cancelLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    cancelLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.cancelLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    approveLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.approveLinkRequest(from: memberID))
        
    }
    
    
    
    
    
     func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    rejectLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.rejectLinkRequest(from: memberID))
        
    }
    
    
    
    
    
     func sendUnlinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    sendUnlinkRequest(to: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sendUnlinkRequest(to: memberID))
        
    }
    
    
    
    
    
     func checkNewLinkRequest() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    checkNewLinkRequest() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.checkNewLinkRequest())
        
    }
    
    

     struct __StubbingProxy_LinkManagementService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fetchUserByNickname<M1: Cuckoo.Matchable>(_ nickname: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), (Data, URLResponse)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nickname) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    fetchUserByNickname(_: String) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchAllLinkedUsers() -> Cuckoo.ProtocolStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    fetchAllLinkedUsers() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchAllReceivedUsers() -> Cuckoo.ProtocolStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    fetchAllReceivedUsers() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchAllRequestUsers() -> Cuckoo.ProtocolStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    fetchAllRequestUsers() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    sendLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func cancelLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    cancelLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func approveLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    approveLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rejectLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    rejectLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendUnlinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    sendUnlinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func checkNewLinkRequest() -> Cuckoo.ProtocolStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockLinkManagementService.self, method:
    """
    checkNewLinkRequest() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_LinkManagementService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fetchUserByNickname<M1: Cuckoo.Matchable>(_ nickname: M1) -> Cuckoo.__DoNotUse<(String), (Data, URLResponse)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nickname) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchUserByNickname(_: String) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchAllLinkedUsers() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchAllLinkedUsers() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchAllReceivedUsers() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchAllReceivedUsers() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchAllRequestUsers() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchAllRequestUsers() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    sendLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func cancelLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    cancelLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func approveLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    approveLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func rejectLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    rejectLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendUnlinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    sendUnlinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func checkNewLinkRequest() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    checkNewLinkRequest() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class LinkManagementServiceStub: LinkManagementService {
    

    

    
    
    
    
     func fetchUserByNickname(_ nickname: String) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func fetchAllLinkedUsers() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func fetchAllReceivedUsers() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func fetchAllRequestUsers() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func sendLinkRequest(to memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func cancelLinkRequest(to memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func sendUnlinkRequest(to memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     func checkNewLinkRequest() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
}










 class MockDefaultLinkManagementService: DefaultLinkManagementService, Cuckoo.ClassMock {
    
     typealias MocksType = DefaultLinkManagementService
    
     typealias Stubbing = __StubbingProxy_DefaultLinkManagementService
     typealias Verification = __VerificationProxy_DefaultLinkManagementService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: DefaultLinkManagementService?

     func enableDefaultImplementation(_ stub: DefaultLinkManagementService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    
    
    
    
     override var networkService: NetworkServiceProvider {
        get {
            return cuckoo_manager.getter("networkService",
                superclassCall:
                    
                                    super.networkService
                    ,
                defaultCall:  __defaultImplStub!.networkService)
        }
        
        set {
            cuckoo_manager.setter("networkService",
                value: newValue,
                superclassCall:
                    
                    super.networkService = newValue
                    ,
                defaultCall: __defaultImplStub!.networkService = newValue)
        }
        
    }
    
    

    

    
    
    
    
     override func fetchUserByNickname(_ nickname: String) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchUserByNickname(_: String) async throws -> (Data, URLResponse)
    """,
            parameters: (nickname),
            escapingParameters: (nickname),
            superclassCall:
                
                await super.fetchUserByNickname(nickname)
                ,
            defaultCall: await __defaultImplStub!.fetchUserByNickname(nickname))
        
    }
    
    
    
    
    
     override func fetchAllLinkedUsers() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchAllLinkedUsers() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                await super.fetchAllLinkedUsers()
                ,
            defaultCall: await __defaultImplStub!.fetchAllLinkedUsers())
        
    }
    
    
    
    
    
     override func fetchAllReceivedUsers() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchAllReceivedUsers() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                await super.fetchAllReceivedUsers()
                ,
            defaultCall: await __defaultImplStub!.fetchAllReceivedUsers())
        
    }
    
    
    
    
    
     override func fetchAllRequestUsers() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchAllRequestUsers() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                await super.fetchAllRequestUsers()
                ,
            defaultCall: await __defaultImplStub!.fetchAllRequestUsers())
        
    }
    
    
    
    
    
     override func sendLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    sendLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                await super.sendLinkRequest(to: memberID)
                ,
            defaultCall: await __defaultImplStub!.sendLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     override func cancelLinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    cancelLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                await super.cancelLinkRequest(to: memberID)
                ,
            defaultCall: await __defaultImplStub!.cancelLinkRequest(to: memberID))
        
    }
    
    
    
    
    
     override func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    approveLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                await super.approveLinkRequest(from: memberID)
                ,
            defaultCall: await __defaultImplStub!.approveLinkRequest(from: memberID))
        
    }
    
    
    
    
    
     override func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    rejectLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                await super.rejectLinkRequest(from: memberID)
                ,
            defaultCall: await __defaultImplStub!.rejectLinkRequest(from: memberID))
        
    }
    
    
    
    
    
     override func sendUnlinkRequest(to memberID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    sendUnlinkRequest(to: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (memberID),
            escapingParameters: (memberID),
            superclassCall:
                
                await super.sendUnlinkRequest(to: memberID)
                ,
            defaultCall: await __defaultImplStub!.sendUnlinkRequest(to: memberID))
        
    }
    
    
    
    
    
     override func checkNewLinkRequest() async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    checkNewLinkRequest() async throws -> (Data, URLResponse)
    """,
            parameters: (),
            escapingParameters: (),
            superclassCall:
                
                await super.checkNewLinkRequest()
                ,
            defaultCall: await __defaultImplStub!.checkNewLinkRequest())
        
    }
    
    

     struct __StubbingProxy_DefaultLinkManagementService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var networkService: Cuckoo.ClassToBeStubbedProperty<MockDefaultLinkManagementService, NetworkServiceProvider> {
            return .init(manager: cuckoo_manager, name: "networkService")
        }
        
        
        
        
        
        func fetchUserByNickname<M1: Cuckoo.Matchable>(_ nickname: M1) -> Cuckoo.ClassStubThrowingFunction<(String), (Data, URLResponse)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nickname) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    fetchUserByNickname(_: String) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchAllLinkedUsers() -> Cuckoo.ClassStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    fetchAllLinkedUsers() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchAllReceivedUsers() -> Cuckoo.ClassStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    fetchAllReceivedUsers() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchAllRequestUsers() -> Cuckoo.ClassStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    fetchAllRequestUsers() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    sendLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func cancelLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    cancelLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func approveLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    approveLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func rejectLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    rejectLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendUnlinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    sendUnlinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func checkNewLinkRequest() -> Cuckoo.ClassStubThrowingFunction<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultLinkManagementService.self, method:
    """
    checkNewLinkRequest() async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_DefaultLinkManagementService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
        
        
        var networkService: Cuckoo.VerifyProperty<NetworkServiceProvider> {
            return .init(manager: cuckoo_manager, name: "networkService", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
    
        
        
        
        @discardableResult
        func fetchUserByNickname<M1: Cuckoo.Matchable>(_ nickname: M1) -> Cuckoo.__DoNotUse<(String), (Data, URLResponse)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: nickname) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchUserByNickname(_: String) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchAllLinkedUsers() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchAllLinkedUsers() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchAllReceivedUsers() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchAllReceivedUsers() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchAllRequestUsers() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    fetchAllRequestUsers() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    sendLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func cancelLinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    cancelLinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func approveLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    approveLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func rejectLinkRequest<M1: Cuckoo.Matchable>(from memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    rejectLinkRequest(from: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendUnlinkRequest<M1: Cuckoo.Matchable>(to memberID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: memberID) { $0 }]
            return cuckoo_manager.verify(
    """
    sendUnlinkRequest(to: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func checkNewLinkRequest() -> Cuckoo.__DoNotUse<(), (Data, URLResponse)> {
            let matchers: [Cuckoo.ParameterMatcher<Void>] = []
            return cuckoo_manager.verify(
    """
    checkNewLinkRequest() async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class DefaultLinkManagementServiceStub: DefaultLinkManagementService {
    
    
    
    
     override var networkService: NetworkServiceProvider {
        get {
            return DefaultValueRegistry.defaultValue(for: (NetworkServiceProvider).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func fetchUserByNickname(_ nickname: String) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func fetchAllLinkedUsers() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func fetchAllReceivedUsers() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func fetchAllRequestUsers() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func sendLinkRequest(to memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func cancelLinkRequest(to memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func approveLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func rejectLinkRequest(from memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func sendUnlinkRequest(to memberID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func checkNewLinkRequest() async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
}




