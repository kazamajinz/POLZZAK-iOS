// MARK: - Mocks generated from file: POLZZAK/DataLayer/Network/Services/StampBoardsService.swift at 2023-09-21 08:25:55 +0000

//
//  StampBoardsService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockStampBoardsService: StampBoardsService, Cuckoo.ProtocolMock {
    
     typealias MocksType = StampBoardsService
    
     typealias Stubbing = __StubbingProxy_StampBoardsService
     typealias Verification = __VerificationProxy_StampBoardsService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: StampBoardsService?

     func enableDefaultImplementation(_ stub: StampBoardsService) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func fetchStampBoardList(for tabState: TabState) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchStampBoardList(for: TabState) async throws -> (Data, URLResponse)
    """,
            parameters: (tabState),
            escapingParameters: (tabState),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.fetchStampBoardList(for: tabState))
        
    }
    
    

     struct __StubbingProxy_StampBoardsService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func fetchStampBoardList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.ProtocolStubThrowingFunction<(TabState), (Data, URLResponse)> where M1.MatchedType == TabState {
            let matchers: [Cuckoo.ParameterMatcher<(TabState)>] = [wrap(matchable: tabState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStampBoardsService.self, method:
    """
    fetchStampBoardList(for: TabState) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_StampBoardsService: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func fetchStampBoardList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.__DoNotUse<(TabState), (Data, URLResponse)> where M1.MatchedType == TabState {
            let matchers: [Cuckoo.ParameterMatcher<(TabState)>] = [wrap(matchable: tabState) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchStampBoardList(for: TabState) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class StampBoardsServiceStub: StampBoardsService {
    

    

    
    
    
    
     func fetchStampBoardList(for tabState: TabState) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
}










 class MockDefaultStampBoardsService: DefaultStampBoardsService, Cuckoo.ClassMock {
    
     typealias MocksType = DefaultStampBoardsService
    
     typealias Stubbing = __StubbingProxy_DefaultStampBoardsService
     typealias Verification = __VerificationProxy_DefaultStampBoardsService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: DefaultStampBoardsService?

     func enableDefaultImplementation(_ stub: DefaultStampBoardsService) {
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
    
    

    

    
    
    
    
     override func fetchStampBoardList(for tabState: TabState) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchStampBoardList(for: TabState) async throws -> (Data, URLResponse)
    """,
            parameters: (tabState),
            escapingParameters: (tabState),
            superclassCall:
                
                await super.fetchStampBoardList(for: tabState)
                ,
            defaultCall: await __defaultImplStub!.fetchStampBoardList(for: tabState))
        
    }
    
    

     struct __StubbingProxy_DefaultStampBoardsService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var networkService: Cuckoo.ClassToBeStubbedProperty<MockDefaultStampBoardsService, NetworkServiceProvider> {
            return .init(manager: cuckoo_manager, name: "networkService")
        }
        
        
        
        
        
        func fetchStampBoardList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.ClassStubThrowingFunction<(TabState), (Data, URLResponse)> where M1.MatchedType == TabState {
            let matchers: [Cuckoo.ParameterMatcher<(TabState)>] = [wrap(matchable: tabState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockDefaultStampBoardsService.self, method:
    """
    fetchStampBoardList(for: TabState) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_DefaultStampBoardsService: Cuckoo.VerificationProxy {
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
        func fetchStampBoardList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.__DoNotUse<(TabState), (Data, URLResponse)> where M1.MatchedType == TabState {
            let matchers: [Cuckoo.ParameterMatcher<(TabState)>] = [wrap(matchable: tabState) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchStampBoardList(for: TabState) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class DefaultStampBoardsServiceStub: DefaultStampBoardsService {
    
    
    
    
     override var networkService: NetworkServiceProvider {
        get {
            return DefaultValueRegistry.defaultValue(for: (NetworkServiceProvider).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func fetchStampBoardList(for tabState: TabState) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
}




