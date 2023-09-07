//
//  LikeButton.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import UIKit

class LikeButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let img = UIImage.SymbolConfiguration(pointSize: 18)
        setImage(UIImage(systemName: "heart", withConfiguration: img), for: .normal)
        backgroundColor = .white
        tintColor = .black
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.size.width / 2
    }
}
