//
//  SortButton.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import UIKit

final class SortButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
         
//        backgroundColor = Constants.Color.background
//        tintColor = Constants.Color.tintColor
        titleLabel?.font = .systemFont(ofSize: 13)
        
        //invalidateIntrinsicContentSize()
        layer.cornerRadius = 5
        layer.borderWidth = Constants.Design.borderWidth
        layer.borderColor = Constants.Color.tintColor.cgColor
        
        
    }
    
    
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    final func setTitle(title: String) {
        self.setTitle(title, for: .normal)
    }
    
    

    
    
}
