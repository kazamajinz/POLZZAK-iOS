//
//  UICollectionView+reloadDataWIthAnimation.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/19.
//

import UIKit

extension UICollectionView {
    func reloadDataWithAnimation() {
        UIView.transition(
            with: self,
            duration: 0.35,
            options: .transitionCrossDissolve,
            animations: { self.reloadData() }
        )
    }
}
