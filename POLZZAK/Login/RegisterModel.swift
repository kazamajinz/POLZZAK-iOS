//
//  RegisterModel.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/08/28.
//

import Foundation
import UIKit

final class RegisterModel {
    var chosenUserType: LoginUserType?
    var fetchedMemberTypeDetailList: [MemberTypeDetailListDTO.MemberTypeDetail]?
    var memberTypeDetailList: [MemberTypeDetail]?
    
    var memberType: Int?
    var nickname: String?
    var profileImage: UIImage?
}

extension RegisterModel {
    func setMemberTypeAndList() {
        if chosenUserType == .child {
            memberTypeDetailList = nil
            if let memberType = fetchedMemberTypeDetailList?.filter({ $0.detail == "아이" }).first?.memberTypeDetailId {
                // TODO: 여기서 memberType을 set해주는게 맞는지 모르겠음. 추후 수정 필요
                self.memberType = memberType
            }
            return
        }
        
        if chosenUserType == .parent {
            guard var list = fetchedMemberTypeDetailList?.filter({ $0.detail != "아이" }).map({ MemberTypeDetail(memberTypeDetailId: $0.memberTypeDetailId, detail: $0.detail) }) else { return }
            list.insert(.init(memberTypeDetailId: nil, detail: "선택해주세요"), at: list.count/2)
            memberTypeDetailList = list
            return
        }
    }
}

struct MemberTypeDetail {
    let memberTypeDetailId: Int?
    let detail: String
}
