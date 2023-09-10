//
//  LikeItem.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import Foundation
import RealmSwift

class LikeItem: Object {
    @Persisted(primaryKey: true) var productId: String
    @Persisted var title: String
    @Persisted var image: String
    @Persisted var price: String
    @Persisted var mallName: String
    
    @Persisted var like: Bool
    @Persisted var date: Date
    
    convenience init(productId: String, title: String, image: String, price: String, mallName: String, like: Bool) {
        self.init()
        
        self.productId = productId
        self.title = title
        self.image = image
        self.price = price
        self.mallName = mallName
        self.like = like
        self.date = Date()
    }
    
}
