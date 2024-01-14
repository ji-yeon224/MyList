//
//  ReusableProtocol.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit

protocol ReusableProtocol {
    static var identifier: String { get }
}

extension UIViewController: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionView: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell: ReusableProtocol {
    public static var identifier: String {
        return String(describing: self)
    }
}
