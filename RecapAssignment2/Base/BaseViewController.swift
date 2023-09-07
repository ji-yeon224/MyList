//
//  BaseViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setConstraints()
        
    }
    
    func configure() {
        view.backgroundColor = Constants.Color.background
    }
    
    func setConstraints() {
        
    }
    
   
    
    func showAlertMessage(title: String, handler: (() -> ())?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default) { _ in
            handler?()
        }
        alert.addAction(ok)
        
        present(alert, animated: true)
    }
    
    
    
}
