//
//  Filterable.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/28.
//

import Foundation

protocol Filterable {
    func handleAllFilterButtonTap()
    func handleChildSectionFilterButtonTap(with family: FamilyMember)
    func handleParentSectionFilterButtonTap(with family: FamilyMember)
}

extension Filterable where Self: BaseFilterView {
    func handleAllFilterButtonTap() {
        sectionStackView.isHidden = true
        filterLabel.isHidden = false
    }
    
    func handleChildSectionFilterButtonTap(with family: FamilyMember) {
        nickNameLabel.text = family.nickname
        memberTypeLabel.text = family.memberType.detail
        sectionStackView.isHidden = false
        memberTypeLabel.isHidden = false
        filterLabel.isHidden = true
    }
    
    func handleParentSectionFilterButtonTap(with family: FamilyMember) {
        nickNameLabel.text = family.nickname
        sectionStackView.isHidden = false
        memberTypeLabel.isHidden = true
        filterLabel.isHidden = true
    }
}
