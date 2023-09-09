//
//  LikeItemRepository.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import Foundation
import RealmSwift

class LikeItemRepository: LikeItemRepositoryType {
    
    let realm = try! Realm()
    
    func fetch() -> Results<LikeItem> {
        let data = realm.objects(LikeItem.self)
        return data
    }
    
    func createItem(_ item: LikeItem) throws {
        
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            throw DataBaseError.createError
        }
    }
    
    func deleteItem(_ item: LikeItem) throws {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            throw DataBaseError.deleteError
        }
    }
    
    func searchItemByTitle(query: String) -> Results<LikeItem> {
        let result = realm.objects(LikeItem.self).where {
            $0.title.like("*\(query)*")
        }
        
        return result
    }
    
    func getRealmFilePath() -> String {
        return "\(realm.configuration.fileURL!)"
    }
    
    
}

