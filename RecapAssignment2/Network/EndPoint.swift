//
//  EndPoint.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import Foundation

enum EndPoint {
    case shop
    
    var requestURL: String {
        switch self {
        case .shop: return URL.makeEndPointString("/shop?query=")
        }
    }
    
}
