//
//  Error.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import Foundation

enum ValidationError: Error {
    case invalidValue
    case isNotInt
    
}

enum DataBaseError: Error {
    case createError
    case updateError
    case deleteError
    case searchError
    
}

enum ImageError: Error {
    case saveImageError
    case removeImageError
}
