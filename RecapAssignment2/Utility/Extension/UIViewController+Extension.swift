//
//  UIViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import UIKit

extension UIViewController  {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
