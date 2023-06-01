//
//  ViewController.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/05/11.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .green
        
        let endpoint = TokenEndpoints.authorize()
        
        let networkService = NetworkService()
        Task {
            let (data, response) = try await networkService.request(with: endpoint)
            print(data.code, data.data, data.messages)
        }
    }
}
