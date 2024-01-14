//
//  SearchBar.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit

final class SearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        barTintColor = Constants.Color.background
        searchTextField.textColor = Constants.Color.text
        searchTextField.tintColor = Constants.Color.tintColor
        showsCancelButton = true
        buttonColor()
        placeholder = "검색어를 입력하세요."
        
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buttonColor() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
   
    
}
