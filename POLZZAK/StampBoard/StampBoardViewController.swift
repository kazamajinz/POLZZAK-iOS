//
//  StampBoardViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/12.
//

import UIKit

import SnapKit

class StampBoardViewController: UIViewController {
    enum Constants {
        static let inset: CGFloat = 16
    }
    
    var missionList: [MissionListViewable] = [
        MissionData(missionNumber: 1, missionTitle: "a"),
        MissionData(missionNumber: 2, missionTitle: "b"),
        MissionData(missionNumber: 3, missionTitle: "c"),
        MissionData(missionNumber: 4, missionTitle: "d"),
        MissionData(missionNumber: 5, missionTitle: "e")
    ]
    
    private let missionListView = MissionListView(inset: Constants.inset)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        configure()
    }
}

extension StampBoardViewController {
    private func configure() {
        configureView()
        configureLayout()
        missionListView.missionListViewDataSource = self
    }
    
    private func configureView() {
        view.addSubview(missionListView)
    }
    
    private func configureLayout() {
        missionListView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

extension StampBoardViewController: MissionListViewDataSource {
    func missionListViewNumberOfItems() -> Int {
        return missionList.count
    }
    
    func missionListView(dataForItemAt indexPath: IndexPath) -> MissionListViewable {
        let data = missionList[indexPath.item]
        return data
    }
}

struct MissionData: MissionListViewable {
    let missionNumber: Int
    let missionTitle: String
}
