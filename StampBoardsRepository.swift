// MARK: - Mocks generated from file: POLZZAK/DomainLayer/Repositories/StampBoardsRepository.swift at 2023-09-18 10:40:16 +0000

//
//  StampBoardsRepository.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/07
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockStampBoardsRepository: StampBoardsRepository, Cuckoo.ProtocolMock {
    
     typealias MocksType = StampBoardsRepository
    
     typealias Stubbing = __StubbingProxy_StampBoardsRepository
     typealias Verification = __VerificationProxy_StampBoardsRepository

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: StampBoardsRepository?

     func enableDefaultImplementation(_ stub: StampBoardsRepository) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func getStampBoardList(for tabState: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError> {
        
    return try await cuckoo_manager.callThrows(
    """
    getStampBoardList(for: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>
    """,
            parameters: (tabState),
            escapingParameters: (tabState),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: await __defaultImplStub!.getStampBoardList(for: tabState))
        
    }
    
    

     struct __StubbingProxy_StampBoardsRepository: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func getStampBoardList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.ProtocolStubThrowingFunction<(String), NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tabState) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStampBoardsRepository.self, method:
    """
    getStampBoardList(for: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_StampBoardsRepository: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func getStampBoardList<M1: Cuckoo.Matchable>(for tabState: M1) -> Cuckoo.__DoNotUse<(String), NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>> where M1.MatchedType == String {
            let matchers: [Cuckoo.ParameterMatcher<(String)>] = [wrap(matchable: tabState) { $0 }]
            return cuckoo_manager.verify(
    """
    getStampBoardList(for: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class StampBoardsRepositoryStub: StampBoardsRepository {
    

    

    
    
    
    
     func getStampBoardList(for tabState: String) async throws -> NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>  {
        return DefaultValueRegistry.defaultValue(for: (NetworkResult<BaseResponse<[StampBoardList]>, NetworkError>).self)
    }
    
    
}




