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
        
        Task {
            do {
                let data = try await AuthAPI().authorize()
                print(data.code, data.data, data.messages)
            } catch {
                print(error)
            }
        }
    }
}
