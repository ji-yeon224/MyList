//
//  URL+Extension.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import Foundation

extension URL {
    static let baseURL = "https://openapi.naver.com/v1/search"
    
    static func makeEndPointString(_ endPoint: String) -> String {
        return baseURL + endPoint
        
    }
}
