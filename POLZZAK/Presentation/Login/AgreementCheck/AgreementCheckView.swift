//
//  AgreementCheckView.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/07/21.
//

import Combine
import UIKit

final class AgreementCheckView: UITableView {
    private var terms: [[AgreementTerm]] = []
    
    private let _allTermsAccepted = PassthroughSubject<Bool, Never>()
    var allTermsAccepted: AnyPublisher<Bool, Never> {
        _allTermsAccepted.eraseToAnyPublisher()
    }
    
    init(frame: CGRect = .zero) {
        super.init(frame: frame, style: .plain)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        allowsSelection = false
        isScrollEnabled = false
        backgroundColor = .clear
        estimatedRowHeight = 44
        rowHeight = UITableView.automaticDimension
        separatorStyle = .none
        dataSource = self
        delegate = self
        register(AgreementCheckCell.self, forCellReuseIdentifier: AgreementCheckCell.reuseIdentifier)
    }
    
    func setTerms(terms: [[AgreementTerm]]) {
        self.terms = terms
        reloadData()
        checkAllTermsAccepted()
    }
}

extension AgreementCheckView: UITableViewDataSource, UITableViewDelegate {
    // MARK: DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return terms.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return terms[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AgreementCheckCell.reuseIdentifier) as? AgreementCheckCell else {
            fatalError("AgreementCheckCell not dequeued properly")
        }
        let term = terms[indexPath.section][indexPath.row]
        cell.configure(data: term)
        cell.agreeAction = { [weak self] in
            self?.didSelectTermCell(indexPath: indexPath)
        }
        cell.rightArrowAction = {
            guard let url = term.contentsURL else { return }
            let topVC = UIApplication.getTopViewController()
            // TODO: WebViewController 구현하기
//            let webViewController = WebViewController(url: url)
//            topVC?.navigationController?.pushViewController(<#T##UIViewController#>, animated: true)
        }
        return cell
    }
    
    // MARK: Select Cell
    
    private func didSelectTermCell(indexPath: IndexPath) {
        if indexPath.row == 0 { // main cell을 선택한 경우 - sub cell모두 main cell과 동일한 상태로 업데이트
            terms[indexPath.section][0].isAccepted.toggle()
            for row in 1..<terms[indexPath.section].count {
                terms[indexPath.section][row].isAccepted = terms[indexPath.section][0].isAccepted
            }
        } else { // sub cell을 선택한 경우 - sub cell에 따라 main cell 업데이트
            terms[indexPath.section][indexPath.row].isAccepted.toggle()
            terms[indexPath.section][0].isAccepted = true
            for row in 1..<terms[indexPath.section].count {
                if !terms[indexPath.section][row].isAccepted {
                    terms[indexPath.section][0].isAccepted = false
                    break
                }
            }
        }
        reloadData()
        checkAllTermsAccepted()
    }
    
    private func checkAllTermsAccepted() {
        for termList in terms {
            for term in termList where !term.isAccepted {
                _allTermsAccepted.send(false)
                return
            }
        }
        _allTermsAccepted.send(true)
    }
}
