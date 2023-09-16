//
//  StampBoardDetailMapper.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/09/15.
//

import Foundation

struct StampBoardDetailMapper {
    func mapStampBoardDetail(from dto: StampBoardDetailDTO) -> StampBoardDetail {
        let status = DetailBoardState(rawValue: dto.status.lowercased())!
        let childInfo = ChildInfo(id: dto.kid.id, nickname: dto.kid.nickname, profileUrl: dto.kid.profileUrl)
        let missions = dto.missions.map { Mission(id: $0.id, content: $0.content) }
        let stamps = dto.stamps?.map {
            StampInfo(
                id: $0.id,
                stampDesignId: $0.stampDesignId,
                missionContent: $0.missionContent,
                createdDate: $0.createdDate.dateFromPolzzakStringDate
            )
        }
        let missionRequestList = dto.missionRequestList?.map {
            MissionRequest(
                id: $0.id,
                missionId: $0.missionId,
                missionContent: $0.missionContent,
                createdDate: $0.createdDate.dateFromPolzzakStringDate
            )
        }
        return .init(
            stampBoardId: dto.stampBoardId,
            name: dto.name,
            status: status,
            kid: childInfo,
            currentStampCount: dto.currentStampCount,
            goalStampCount: dto.goalStampCount,
            reward: dto.reward,
            missions: missions,
            stamps: stamps,
            missionRequestList: missionRequestList,
            completedDate: dto.completedDate?.dateFromPolzzakStringDate,
            rewardDate: dto.rewardDate?.dateFromPolzzakStringDate,
            createdDate: dto.createdDate.dateFromPolzzakStringDate
        )
    }
}

extension String {
    var dateFromPolzzakStringDate: Date {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime, .withFractionalSeconds]
        dateFormatter.timeZone = .init(abbreviation: "KST")
        let date = dateFormatter.date(from: self)!
        return date
    }
}
