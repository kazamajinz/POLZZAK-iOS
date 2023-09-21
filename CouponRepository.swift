// MARK: - Mocks generated from file: POLZZAK/DomainLayer/Repositories/CouponRepository.swift at 2023-09-18 10:40:16 +0000

//
//  CouponRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockCouponRepository: CouponRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = CouponRepository
    
     typealias Stubbing = __StubbingProxy_CouponRepository
     typealias Verification = __VerificationProxy_CouponRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: CouponRepository?

     func enableDefaultImplementation(_ stub: CouponRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getCouponList(_ tabState: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    getCouponList(_: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError>
    """,
            parameters: (tabState),
            escapingParameters: (tabState),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getCouponList(tabState))
        
    }
    
    
    
    
    
     func getCouponDetail(with couponID: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    getCouponDetail(with: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError>
    """,
            parameters: (couponID),
            escapingParameters: (couponID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getCouponDetail(with: couponID))
        
    }
    
    
    
    
    
     func createGiftRequest(with couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    createGiftRequest(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """,
            parameters: (couponID),
            escapingParameters: (couponID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.createGiftRequest(with: couponID))
        
    }
    
    
    
    
    
     func acceptCoupon(from stampBoardID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    acceptCoupon(from: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    """,
            parameters: (stampBoardID),
            escapingParameters: (stampBoardID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.acceptCoupon(from: stampBoardID))
        
    }
    
    
    
    
    
     func sendGiftReceive(from couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    sendGiftReceive(from: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """,
            parameters: (couponID),
            escapingParameters: (couponID),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.sendGiftReceive(from: couponID))
        
    }
    
    

     struct __StubbingProxy_CouponRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getCouponList<M1: Cuckoo.Matchable>(_ tabState: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), NetworkResult<BaseResponse<[CouponList]>, NetworkError>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tabState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponRepository.self, method:
    """
    getCouponList(_: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func getCouponDetail<M1: Cuckoo.Matchable>(with couponID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<CouponDetail>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponRepository.self, method:
    """
    getCouponDetail(with: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func createGiftRequest<M1: Cuckoo.Matchable>(with couponID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponRepository.self, method:
    """
    createGiftRequest(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func acceptCoupon<M1: Cuckoo.Matchable>(from stampBoardID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: stampBoardID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponRepository.self, method:
    """
    acceptCoupon(from: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
        
        
        func sendGiftReceive<M1: Cuckoo.Matchable>(from couponID: M1) -> Cuckoo.ProtocolStubThrowingFunction<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockCouponRepository.self, method:
    """
    sendGiftReceive(from: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_CouponRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getCouponList<M1: Cuckoo.Matchable>(_ tabState: M1) -> Cuckoo.__DoNotUse<(String), NetworkResult<BaseResponse<[CouponList]>, NetworkError>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tabState) { $0 }]
            return cuckoo_manager.verify(
    """
    getCouponList(_: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func getCouponDetail<M1: Cuckoo.Matchable>(with couponID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<CouponDetail>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return cuckoo_manager.verify(
    """
    getCouponDetail(with: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func createGiftRequest<M1: Cuckoo.Matchable>(with couponID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return cuckoo_manager.verify(
    """
    createGiftRequest(with: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func acceptCoupon<M1: Cuckoo.Matchable>(from stampBoardID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: stampBoardID) { $0 }]
            return cuckoo_manager.verify(
    """
    acceptCoupon(from: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
        
        
        @discardableResult
        func sendGiftReceive<M1: Cuckoo.Matchable>(from couponID: M1) -> Cuckoo.__DoNotUse<(Int), NetworkResult<BaseResponse<Void>, NetworkError>> where M1.MatchedType == Int {
            let matchers: [Cuckoo.ParameterMatcher<(Int)>] = [wrap(matchable: couponID) { $0 }]
            return cuckoo_manager.verify(
    """
    sendGiftReceive(from: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class CouponRepositoryStub: CouponRepository {
    

    

    
    
    
    
     func getCouponList(_ tabState: String) async throws -> NetworkResult<BaseResponse<[CouponList]>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<[CouponList]>, NetworkError>).self)
    }
    
    
    
    
    
     func getCouponDetail(with couponID: Int) async throws -> NetworkResult<BaseResponse<CouponDetail>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<CouponDetail>, NetworkError>).self)
    }
    
    
    
    
    
     func createGiftRequest(with couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
    
    
    
     func acceptCoupon(from stampBoardID: Int) async throws -> NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<EmptyDataResponse>, NetworkError>).self)
    }
    
    
    
    
    
     func sendGiftReceive(from couponID: Int) async throws -> NetworkResult<BaseResponse<Void>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<Void>, NetworkError>).self)
    }
    
    
}




