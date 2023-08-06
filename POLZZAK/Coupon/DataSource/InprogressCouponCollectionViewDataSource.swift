//
//  InprogressCouponCollectionViewDataSource.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/06.
//

import UIKit

class InprogressCouponCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let viewModel: CouponListViewModel
    
    init(viewModel: CouponListViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch viewModel.inprogressFilterType {
        case .all:
            return viewModel.inprogressCouponListData.count
        case .section:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount: Int = 0
        switch viewModel.inprogressFilterType {
        case .all:
            cellCount = viewModel.inprogressCouponListData[section].coupons.count
        case .section(let index):
            cellCount = viewModel.inprogressCouponListData[index].coupons.count
        }
        
        return cellCount == 0 ? 1 : cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.inprogressCouponListData[indexPath.section].coupons.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CouponEmptyCell.reuseIdentifier, for: indexPath) as! CouponEmptyCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressCouponCell.reuseIdentifier, for: indexPath) as! InprogressCouponCell
            let couponData = viewModel.inprogressCouponListData[indexPath.section].coupons[indexPath.row]
            cell.configure(with: couponData, userType: viewModel.userType)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CouponHeaderView.reuseIdentifier, for: indexPath) as! CouponHeaderView
            if viewModel.inprogressCouponListData.isEmpty {
                return headerView
            }
            
            let family = viewModel.inprogressCouponListData[indexPath.section].family
            headerView.configure(to: family, type: viewModel.userType)
            
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CouponFooterView.reuseIdentifier, for: indexPath) as! CouponFooterView
            let totalCount = viewModel.inprogressCouponListData[indexPath.section].coupons.count
            if totalCount != 0 {
                footerView.configure(with: totalCount)
            }
            
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
}
