//
//  CouponCollectionViewDataSource.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit

class CouponCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let viewModel: CouponListViewModel
    
    var isEmptyCollectionView: Bool {
        return viewModel.couponListData.isEmpty
    }
    
    var tabState: TabState {
        return viewModel.tabState
    }
    
    init(viewModel: CouponListViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch viewModel.filterType {
        case .all:
            return viewModel.couponListData.count
        case .section:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount: Int = 0
        switch viewModel.filterType {
        case .all:
            cellCount = viewModel.couponListData[section].coupons.count
        case .section(let memberId):
            if false == viewModel.couponListData.isEmpty {
                let index = viewModel.indexOfMember(with: memberId)
                cellCount = viewModel.couponListData[index].coupons.count
            } else {
                return 0
            }
        }
        
        return cellCount == 0 ? 1 : cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case .section(let memberId) = viewModel.filterType {
            let index = viewModel.indexOfMember(with: memberId)
            if true == viewModel.couponListData[index].coupons.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        }
        
        if viewModel.filterType == .all {
            if true == viewModel.couponListData[indexPath.section].coupons.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        }
        
        if true == isEmptyCollectionView {
            return dequeueEmptyCell(in: collectionView, at: indexPath)
        }
        
        switch tabState {
        case .completed:
            return dequeueCompletedCouponCell(in: collectionView, at: indexPath)
        default:
            return dequeueInProgressCouponCell(in: collectionView, at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CouponHeaderView.reuseIdentifier, for: indexPath) as! CouponHeaderView
            if false == viewModel.couponListData.isEmpty {
                let family = viewModel.couponListData[indexPath.section].family
                headerView.configure(to: family, type: viewModel.userType)
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CouponFooterView.reuseIdentifier, for: indexPath) as! CouponFooterView
            let totalCount = viewModel.couponListData[indexPath.section].coupons.count
            if totalCount != 0 {
                footerView.configure(with: totalCount)
            }
            
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
    
    private func dequeueEmptyCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponEmptyCell.reuseIdentifier, for: indexPath) as! CouponEmptyCell
        return cell
    }
    
    private func dequeueCompletedCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedCouponCell.reuseIdentifier, for: indexPath) as! CompletedCouponCell
        switch viewModel.filterType {
        case .all:
            let couponData = viewModel.couponListData[indexPath.section].coupons[indexPath.row]
            cell.configure(with: couponData)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let couponData = viewModel.couponListData[index].coupons[indexPath.row]
            cell.configure(with: couponData)
        }
        return cell
    }
    
    private func dequeueInProgressCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressCouponCell.reuseIdentifier, for: indexPath) as! InprogressCouponCell
        switch viewModel.filterType {
        case .all:
            let couponData = viewModel.couponListData[indexPath.section].coupons[indexPath.row]
            cell.configure(with: couponData, userType: viewModel.userType)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let couponData = viewModel.couponListData[index].coupons[indexPath.row]
            cell.configure(with: couponData, userType: viewModel.userType)
        }
        return cell
    }
}
