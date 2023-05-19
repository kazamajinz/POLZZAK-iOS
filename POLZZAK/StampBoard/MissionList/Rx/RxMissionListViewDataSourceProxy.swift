//
//  RxMissionListViewDataSourceProxy.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/18.
//

import UIKit

import RxCocoa

//class RxMissionListViewDataSourceProxy: DelegateProxy<MissionListView, MissionListViewDataSource>, DelegateProxyType, MissionListViewDataSource {
//    static func registerKnownImplementations() {
//        self.register { missionListView in
//            RxMissionListViewDataSourceProxy(parentObject: missionListView, delegateProxy: self)
//        }
//    }
//    
//    static func currentDelegate(for object: MissionListView) -> MissionListViewDataSource? {
//        return object.missionListViewDataSource
//    }
//    
//    static func setCurrentDelegate(_ delegate: MissionListViewDataSource?, to object: MissionListView) {
//        object.missionListViewDataSource = delegate
//    }
//    
//    func missionListViewNumberOfItems() -> Int {
//        <#code#>
//    }
//    
//    func missionListView(dataForItemAt indexPath: IndexPath) -> MissionListViewable {
//        <#code#>
//    }
//}
