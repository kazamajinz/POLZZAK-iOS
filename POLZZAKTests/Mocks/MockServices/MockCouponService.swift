// MARK: - Mocks generated from file: POLZZAK/DataLayer/Network/Services/CouponService.swift at 2023-09-21 08:25:55 +0000

//
//  CouponService.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockCouponService: CouponService, Cuckoo.ClassMock {
    
     typealias MocksType = CouponService
    
     typealias Stubbing = __StubbingProxy_CouponService
     typealias Verification = __VerificationProxy_CouponService

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)

    
    private var __defaultImplStub: CouponService?

     func enableDefaultImplementation(_ stub: CouponService) {
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
    
    

    

    
    
    
    
     override func fetchCouponList(for tabState: String) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchCouponList(for: String) async throws -> (Data, URLResponse)
    """,
            parameters: (tabState),
            escapingParameters: (tabState),
            superclassCall:
                
                await super.fetchCouponList(for: tabState)
                ,
            defaultCall: await __defaultImplStub!.fetchCouponList(for: tabState))
        
    }
    
    
    
    
    
     override func fetchCouponDetail(with couponID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    fetchCouponDetail(with: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (couponID),
            escapingParameters: (couponID),
            superclassCall:
                
                await super.fetchCouponDetail(with: couponID)
                ,
            defaultCall: await __defaultImplStub!.fetchCouponDetail(with: couponID))
        
    }
    
    
    
    
    
     override func sendGiftRequest(to couponID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    sendGiftRequest(to: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (couponID),
            escapingParameters: (couponID),
            superclassCall:
                
                await super.sendGiftRequest(to: couponID)
                ,
            defaultCall: await __defaultImplStub!.sendGiftRequest(to: couponID))
        
    }
    
    
    
    
    
     override func acceptCoupon(from stampBoardID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    acceptCoupon(from: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (stampBoardID),
            escapingParameters: (stampBoardID),
            superclassCall:
                
                await super.acceptCoupon(from: stampBoardID)
                ,
            defaultCall: await __defaultImplStub!.acceptCoupon(from: stampBoardID))
        
    }
    
    
    
    
    
     override func sendGiftReceive(from couponID: Int) async throws -> (Data, URLResponse) {
        
    return try await cuckoo_manager.callThrows(
    """
    sendGiftReceive(from: Int) async throws -> (Data, URLResponse)
    """,
            parameters: (couponID),
            escapingParameters: (couponID),
            superclassCall:
                
                await super.sendGiftReceive(from: couponID)
                ,
            defaultCall: await __defaultImplStub!.sendGiftReceive(from: couponID))
        
    }
    
    

     struct __StubbingProxy_CouponService: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        var networkService: Cuckoo.ClassToBeStubbedProperty<MockCouponService, NetworkServiceProvider> {
            return .init(manager: cuckoo_manager, name: "networkService")
        }
        
        
        
        
        
        func fetchCouponList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.ClassStubThrowingFunction<(String), (Data, URLResponse)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tabState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponService.self, method:
    """
    fetchCouponList(for: String) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func fetchCouponDetail<M1: Cuckoo.Matchable>(with couponID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponService.self, method:
    """
    fetchCouponDetail(with: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendGiftRequest<M1: Cuckoo.Matchable>(to couponID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponService.self, method:
    """
    sendGiftRequest(to: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func acceptCoupon<M1: Cuckoo.Matchable>(from stampBoardID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: stampBoardID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponService.self, method:
    """
    acceptCoupon(from: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendGiftReceive<M1: Cuckoo.Matchable>(from couponID: M1) -> Cuckoo.ClassStubThrowingFunction<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponService.self, method:
    """
    sendGiftReceive(from: Int) async throws -> (Data, URLResponse)
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CouponService: Cuckoo.VerificationProxy {
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
        func fetchCouponList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.__DoNotUse<(String), (Data, URLResponse)> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tabState) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchCouponList(for: String) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func fetchCouponDetail<M1: Cuckoo.Matchable>(with couponID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return cuckoo_manager.verify(
    """
    fetchCouponDetail(with: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendGiftRequest<M1: Cuckoo.Matchable>(to couponID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return cuckoo_manager.verify(
    """
    sendGiftRequest(to: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func acceptCoupon<M1: Cuckoo.Matchable>(from stampBoardID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: stampBoardID) { $0 }]
            return cuckoo_manager.verify(
    """
    acceptCoupon(from: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendGiftReceive<M1: Cuckoo.Matchable>(from couponID: M1) -> Cuckoo.__DoNotUse<(Int), (Data, URLResponse)> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return cuckoo_manager.verify(
    """
    sendGiftReceive(from: Int) async throws -> (Data, URLResponse)
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class CouponServiceStub: CouponService {
    
    
    
    
     override var networkService: NetworkServiceProvider {
        get {
            return DefaultValueRegistry.defaultValue(for: (NetworkServiceProvider).self)
        }
        
        set { }
        
    }
    
    

    

    
    
    
    
     override func fetchCouponList(for tabState: String) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func fetchCouponDetail(with couponID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func sendGiftRequest(to couponID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func acceptCoupon(from stampBoardID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
    
    
    
     override func sendGiftReceive(from couponID: Int) async throws -> (Data, URLResponse)  {
        return DefaultValueRegistry.defaultValue(for: ((Data, URLResponse)).self)
    }
    
    
}




