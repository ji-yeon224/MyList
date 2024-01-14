//
//  LikeButtonProtocol.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import UIKit

protocol LikeButtonProtocol: AnyObject {
    func buttonClickedAction(indexPath: IndexPath, image: UIImage?)
}
