//
//  NumberFomatter+Extension.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit

extension Int {
    
    func numberFormatter() -> String {
        let numFomatter = NumberFormatter()
        numFomatter.numberStyle = .decimal
        return numFomatter.string(from: NSNumber(value: self)) ?? "0"
    }
    
}
