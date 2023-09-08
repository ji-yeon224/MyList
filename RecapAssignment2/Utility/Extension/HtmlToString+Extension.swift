//
//  HtmlToString+Extension.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import Foundation

extension String {
    func htmlToString() -> String {
        return  try! NSAttributedString(data: self.data(using: .utf8)!,
                                        options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue],
                                        documentAttributes: nil).string
    }
}
