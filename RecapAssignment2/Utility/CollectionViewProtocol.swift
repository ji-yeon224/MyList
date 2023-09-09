//
//  CollectionViewProtocol.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import Foundation

protocol CollectionViewProtocol: AnyObject {
    func didSelectRowItemAt(indexPath: IndexPath)
}
