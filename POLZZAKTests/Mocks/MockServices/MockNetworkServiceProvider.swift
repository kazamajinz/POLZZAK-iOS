// MARK: - Mocks generated from file: POLZZAK/Network/NetworkService/NetworkService.swift at 2023-09-21 08:25:55 +0000

//
//  NetworkService.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/29.
//

import Cuckoo
@testable import POLZZAK

import Foundation
import OSLog






 class MockNetworkServiceProvider: NetworkServiceProvider, Cuckoo.ProtocolMock {
    
     typealias MocksType = NetworkServiceProvider
    
     typealias Stubbing = __StubbingProxy_NetworkServiceProvider
     typealias Verification = __VerificationProxy_NetworkServiceProvider

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: NetworkServiceProvider?

     func enableDefaultImplementation(_ stub: NetworkServiceProvider) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func request(with target: TargetType) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    request(with: TargetType) async throws -> (Data, URLResponse)
    """,
            parameters: (target),
            escapingParameters: (target),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.request(with: target))
        
    }
    
    

     struct __StubbingProxy_NetworkServiceProvider: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func request<M1: Cuckoo.Matchable>(with target: M1) -> Cuckoo.ProtocolStubThrowingFunction<(TargetType), (Data, URLResponse)> where M1.MatchedType == TargetType {
            let matchers: [Cuckoo.ParameterMatcher<(TargetType)>] = [wrap(matchable: target) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockNetworkServiceProvider.self, method:
    """
    request(with: TargetType) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_NetworkServiceProvider: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func request<M1: Cuckoo.Matchable>(with target: M1) -> Cuckoo.__DoNotUse<(TargetType), (Data, URLResponse)> where M1.MatchedType == TargetType {
            let matchers: [Cuckoo.ParameterMatcher<(TargetType)>] = [wrap(matchable: target) { $0 }]
            return cuckoo_manager.verify(
    """
    request(with: TargetType) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class NetworkServiceProviderStub: NetworkServiceProvider {
    

    

    
    
    
    
     func request(with target: TargetType) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
}




