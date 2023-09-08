//
//  ItemStruct.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import Foundation

struct Search: Codable {
    let lastBuildDate: String
    let total, start, display: Int
    let items: [ItemElement]
}

// MARK: - ItemElement
struct ItemElement: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice: String
    let mallName: String
    let productID: String
    
    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
    }
}
