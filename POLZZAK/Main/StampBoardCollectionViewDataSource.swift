//
//  StampBoardCollectionViewDataSource.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/24.
//

import UIKit

class StampBoardCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let viewModel: StampBoardViewModel
    
    var isEmptyCollectionView: Bool {
        return viewModel.dataList.value.isEmpty
    }
    
    var tabState: TabState {
        return viewModel.tabState.value
    }
    
    init(viewModel: StampBoardViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch viewModel.filterType.value {
        case .all:
            return viewModel.dataList.value.count
        case .section:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount: Int = 0
        switch viewModel.filterType.value {
        case .all:
            cellCount = viewModel.dataList.value[section].stampBoardSummaries.count
        case .section(let memberId):
            if false == viewModel.dataList.value.isEmpty {
                let index = viewModel.indexOfMember(with: memberId)
                cellCount = viewModel.dataList.value[index].stampBoardSummaries.count
            } else {
                return 0
            }
        }
        
        return cellCount == 0 ? 1 : cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case .section(let memberId) = viewModel.filterType.value {
            let index = viewModel.indexOfMember(with: memberId)
            if true == viewModel.dataList.value[index].stampBoardSummaries.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        }
        
        if viewModel.filterType.value == .all {
            if true == viewModel.dataList.value[indexPath.section].stampBoardSummaries.isEmpty {
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
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampBoardHeaderView.reuseIdentifier, for: indexPath) as! StampBoardHeaderView
            if false == viewModel.dataList.value.isEmpty {
                let family = viewModel.dataList.value[indexPath.section].family
                headerView.configure(to: family, type: viewModel.userType.value)
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampBoardFooterView.reuseIdentifier, for: indexPath) as! StampBoardFooterView
            let totalCount = viewModel.dataList.value[indexPath.section].stampBoardSummaries.count
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompletedStampBoardCell.reuseIdentifier, for: indexPath) as! CompletedStampBoardCell
        switch viewModel.filterType.value {
        case .all:
            let boardData = viewModel.dataList.value[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let boardData = viewModel.dataList.value[index].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        }
        return cell
    }
    
    private func dequeueInProgressCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressStampBoardCell.reuseIdentifier, for: indexPath) as! InprogressStampBoardCell
        switch viewModel.filterType.value {
        case .all:
            let boardData = viewModel.dataList.value[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let boardData = viewModel.dataList.value[index].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        }
        return cell
    }
}
