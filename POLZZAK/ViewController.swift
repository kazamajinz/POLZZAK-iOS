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
        
        let api = AuthAPI.authorize
        let networkService = NetworkService(requestInterceptor: api.intercetpr)
        Task {
            do {
                let data = try await networkService.requestData(responseType: TokenResponseDTO.self, with: api)
                print(data.code, data.data, data.messages)
            } catch {
                print(error)
            }
        }
    }
}
