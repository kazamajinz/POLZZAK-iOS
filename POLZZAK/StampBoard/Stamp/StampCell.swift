//
//  StampCell.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/22.
//

import UIKit

class StampCell: UICollectionViewCell {
    static let reuseIdentifier = "StampCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2
    }
}
