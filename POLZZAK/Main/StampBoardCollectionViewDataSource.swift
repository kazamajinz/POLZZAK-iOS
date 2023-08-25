//
//  StampBoardCollectionViewDataSource.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/24.
//

import UIKit

class StampBoardCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    let viewModel: MainViewModel
    
    var isEmptyCollectionView: Bool {
        return viewModel.stampBoardListData.isEmpty
    }
    
    var tabState: TabState {
        return viewModel.tabState
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch viewModel.filterType {
        case .all:
            return viewModel.stampBoardListData.count
        case .section:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cellCount: Int = 0
        switch viewModel.filterType {
        case .all:
            cellCount = viewModel.stampBoardListData[section].stampBoardSummaries.count
        case .section(let memberId):
            if false == viewModel.stampBoardListData.isEmpty {
                let index = viewModel.indexOfMember(with: memberId)
                cellCount = viewModel.stampBoardListData[index].stampBoardSummaries.count
            } else {
                return 0
            }
        }
        
        return cellCount == 0 ? 1 : cellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if case .section(let memberId) = viewModel.filterType {
            let index = viewModel.indexOfMember(with: memberId)
            if true == viewModel.stampBoardListData[index].stampBoardSummaries.isEmpty {
                return dequeueEmptyCell(in: collectionView, at: indexPath)
            }
        }
        
        if viewModel.filterType == .all {
            if true == viewModel.stampBoardListData[indexPath.section].stampBoardSummaries.isEmpty {
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
            if false == viewModel.stampBoardListData.isEmpty {
                let family = viewModel.stampBoardListData[indexPath.section].familyMember
                headerView.configure(to: family, type: viewModel.userType)
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: StampBoardFooterView.reuseIdentifier, for: indexPath) as! StampBoardFooterView
            let totalCount = viewModel.stampBoardListData[indexPath.section].stampBoardSummaries.count
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
        switch viewModel.filterType {
        case .all:
            let boardData = viewModel.stampBoardListData[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let boardData = viewModel.stampBoardListData[index].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        }
        return cell
    }
    
    private func dequeueInProgressCouponCell(in collectionView: UICollectionView, at indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InprogressStampBoardCell.reuseIdentifier, for: indexPath) as! InprogressStampBoardCell
        switch viewModel.filterType {
        case .all:
            let boardData = viewModel.stampBoardListData[indexPath.section].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        case .section(let memberId):
            let index = viewModel.indexOfMember(with: memberId)
            let boardData = viewModel.stampBoardListData[index].stampBoardSummaries[indexPath.row]
            cell.configure(with: boardData)
        }
        return cell
    }
}
