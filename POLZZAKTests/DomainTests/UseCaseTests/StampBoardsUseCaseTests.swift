//
//  StampBoardsUseCaseTests.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/18.
//

//@testable import POLZZAK

import Quick
import Nimble
import Cuckoo

//class StampBoardsUseCaseSpec: QuickSpec {
//    override func spec() {
//        describe("StampBoardsUseCase") {
//            var useCase: DefaultStampBoardsUseCase!
//            var mockRepository: MockStampBoardsRepository!
//
//            beforeEach {
//                mockRepository = MockStampBoardsRepository()
//                useCase = DefaultStampBoardsUseCase(repository: mockRepository)
//            }
//
//            context("when fetching stamp board list") {
//                it("returns the expected stamp boards") {
//                    let familyMember = FamilyMember(
//                        memberID: 1,
//                        nickname: "John",
//                        memberType: MemberType(name: "TypeA", detail: "DetailA"),
//                        profileURL: nil,
//                        familyStatus: .none
//                    )
//
//                    let stampBoardSummary = StampBoardSummary(
//                        stampBoardId: 1,
//                        name: "BoardA",
//                        currentStampCount: 3,
//                        goalStampCount: 10,
//                        reward: "RewardA",
//                        missionRequestCount: 2,
//                        status: .progress
//                    )
//
//                    let tabState = "someState"
//                    let expectedStampBoards = [StampBoardList(family: familyMember, stampBoardSummaries: [stampBoardSummary])]
//
//                    stub(mockRepository) { stub in
//                        when(stub.getStampBoardList(for: tabState)).thenReturn(Task { return expectedStampBoards })
//                    }
//
//                    let result = try? await useCase.fetchStampBoardList(for: tabState).value
//                    expect(result).to(equal(expectedStampBoards))
//                }
//            }
//
//            afterEach {
//                mockRepository = nil
//                useCase = nil
//            }
//        }
//    }
//}
