//
//  ItemImageView.swift
//  RecapAssignment2
//
//  Created by 김지연 on 12/29/23.
//

import UIKit

final class ItemImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .scaleAspectFill
        layer.cornerRadius = Constants.Design.cornerRadius
        clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
