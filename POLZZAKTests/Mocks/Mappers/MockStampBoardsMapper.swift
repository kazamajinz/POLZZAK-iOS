// MARK: - Mocks generated from file: POLZZAK/DataLayer/Network/Mappers/StampBoardsMapper.swift at 2023-09-21 08:25:55 +0000

//
//  StampBoardsMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/30
import Cuckoo
@testable import POLZZAK

import Foundation






 class MockStampBoardsMapper: StampBoardsMapper, Cuckoo.ProtocolMock {
    
     typealias MocksType = StampBoardsMapper
    
     typealias Stubbing = __StubbingProxy_StampBoardsMapper
     typealias Verification = __VerificationProxy_StampBoardsMapper

     let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: false)

    
    private var __defaultImplStub: StampBoardsMapper?

     func enableDefaultImplementation(_ stub: StampBoardsMapper) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    

    

    

    
    
    
    
     func mapStampBoardListResponse(from response: BaseResponseDTO<[StampBoardListDTO]>) -> BaseResponse<[StampBoardList]> {
        
    return cuckoo_manager.call(
    """
    mapStampBoardListResponse(from: BaseResponseDTO<[StampBoardListDTO]>) -> BaseResponse<[StampBoardList]>
    """,
            parameters: (response),
            escapingParameters: (response),
            superclassCall:
                
                Cuckoo.MockManager.crashOnProtocolSuperclassCall()
                ,
            defaultCall: __defaultImplStub!.mapStampBoardListResponse(from: response))
        
    }
    
    

     struct __StubbingProxy_StampBoardsMapper: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
    
         init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        
        
        func mapStampBoardListResponse<M1: Cuckoo.Matchable>(from response: M1) -> Cuckoo.ProtocolStubFunction<(BaseResponseDTO<[StampBoardListDTO]>), BaseResponse<[StampBoardList]>> where M1.MatchedType == BaseResponseDTO<[StampBoardListDTO]> {
            let matchers: [Cuckoo.ParameterMatcher<(BaseResponseDTO<[StampBoardListDTO]>)>] = [wrap(matchable: response) { $0 }]
            return .init(stub: cuckoo_manager.createStub(for: MockStampBoardsMapper.self, method:
    """
    mapStampBoardListResponse(from: BaseResponseDTO<[StampBoardListDTO]>) -> BaseResponse<[StampBoardList]>
    """, parameterMatchers: matchers))
        }
        
        
    }

     struct __VerificationProxy_StampBoardsMapper: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
    
         init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
    
        
    
        
        
        
        @discardableResult
        func mapStampBoardListResponse<M1: Cuckoo.Matchable>(from response: M1) -> Cuckoo.__DoNotUse<(BaseResponseDTO<[StampBoardListDTO]>), BaseResponse<[StampBoardList]>> where M1.MatchedType == BaseResponseDTO<[StampBoardListDTO]> {
            let matchers: [Cuckoo.ParameterMatcher<(BaseResponseDTO<[StampBoardListDTO]>)>] = [wrap(matchable: response) { $0 }]
            return cuckoo_manager.verify(
    """
    mapStampBoardListResponse(from: BaseResponseDTO<[StampBoardListDTO]>) -> BaseResponse<[StampBoardList]>
    """, callMatcher: callMatcher, parameterMatchers: matchers, sourceLocation: sourceLocation)
        }
        
        
    }
}


 class StampBoardsMapperStub: StampBoardsMapper {
    

    

    
    
    
    
     func mapStampBoardListResponse(from response: BaseResponseDTO<[StampBoardListDTO]>) -> BaseResponse<[StampBoardList]>  {
        return DefaultValueRegistry.defaultValue(for: (BaseResponse<[StampBoardList]>).self)
    }
    
    
}




