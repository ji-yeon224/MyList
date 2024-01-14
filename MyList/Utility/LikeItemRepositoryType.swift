//
//  LikeItemRepositoryType.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import Foundation
import RealmSwift

protocol LikeItemRepositoryType: AnyObject {
    
    func fetch() -> Results<LikeItem> //전체 조회
    func createItem(_ item: LikeItem) throws
    func deleteItem(_ item: LikeItem) throws
    func searchItemByTitle(query: String) -> Results<LikeItem>
    
    
}
