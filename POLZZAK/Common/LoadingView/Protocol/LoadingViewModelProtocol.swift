//
//  LoadingViewModelProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/27.
//

import Foundation
import Combine

protocol LoadingViewModelProtocol: AnyObject {
    var isSkeleton: CurrentValueSubject<Bool, Never> { get }
    var isCenterLoading: CurrentValueSubject<Bool, Never> { get }
    
    func hideSkeletonView()
    func showLoading(for centerLoading: Bool)
    func hideLoading(for centerLoading: Bool)
}

extension LoadingViewModelProtocol {
    func hideSkeletonView() {
        isSkeleton.send(false)
    }
    
    func showLoading(for centerLoading: Bool) {
        if true == centerLoading {
            isCenterLoading.send(true)
        }
    }
    
    func hideLoading(for centerLoading: Bool) {
        if isSkeleton.value == true {
            self.hideSkeletonView()
        } else if true == centerLoading {
            isCenterLoading.send(false)
        }
    }
}
