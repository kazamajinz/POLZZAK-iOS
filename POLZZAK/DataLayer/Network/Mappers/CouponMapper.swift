//
//  CouponMapper.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/08.
//

import Foundation

struct CouponMapper {
    private func mapBaseResponse<T, U>(from dto: BaseResponseDTO<T>, transform: (T) -> U) -> BaseResponse<U> {
        let transformedData = dto.data.map(transform)
        return BaseResponse(status: .success, code: dto.code, messages: dto.messages, data: transformedData)
    }
    
    func mapCouponListResponse(from response: BaseResponseDTO<[CouponListDTO]>) -> BaseResponse<[CouponList]> {
        return mapBaseResponse(from: response, transform: mapCouponList)
    }
    
    func mapCouponDetailResponse(from response: BaseResponseDTO<CouponDetailDTO>) -> BaseResponse<CouponDetail> {
        return mapBaseResponse(from: response, transform: mapCouponDetail)
    }
    
    private func mapCouponList(_ dto: [CouponListDTO]) -> [CouponList] {
        return dto.map{
            CouponList(
                family: mapFamilyMember($0.family),
                coupons: mapCoupons($0.coupons)
            )
        }
    }
    
    private func mapFamilyMember(_ dto: FamilyMemberDTO) -> FamilyMember {
        return FamilyMember(
            memberID: dto.memberId,
            nickname: dto.nickname,
            memberType: mapMemberType(dto.memberType),
            profileURL: dto.profileUrl ?? "",
            familyStatus: nil
        )
    }
    
    private func mapCoupon(_ dto: CouponDTO) -> Coupon {
        return Coupon(
            couponID: dto.couponID,
            reward: dto.reward,
            rewardRequestDate: dto.rewardRequestDate,
            rewardDate: dto.rewardDate
        )
    }
    
    private func mapMemberType(_ dto: MemberTypeDTO) -> MemberType {
        return MemberType(
            name: dto.name,
            detail: dto.detail
        )
    }
    
    private func mapCoupons(_ dto: [CouponDTO]) -> [Coupon] {
        return dto.compactMap { mapCoupon($0) }
    }
    
    private func mapCouponDetail(_ dto: CouponDetailDTO) -> CouponDetail {
        return CouponDetail(
            couponID: dto.couponID,
            reward: dto.reward,
            guardian: mapGuardian(dto.guardian),
            kid: mapGuardian(dto.kid),
            missionContents: dto.missionContents,
            stampCount: dto.stampCount,
            couponState: mapCouponState(dto.state),
            rewardDate: dto.rewardDate,
            rewardRequestDate: dto.rewardRequestDate,
            startDate: dto.startDate,
            endDate: dto.endDate
        )
    }
    
    private func mapGuardian(_ dto: GuardianDTO) -> Guardian {
        return Guardian(
            nickname: dto.nickname,
            profileURL: dto.profileURL
        )
    }
    
    private func mapCouponState(_ stateString: String) -> CouponState? {
        return CouponState(rawValue: stateString)
    }
}
