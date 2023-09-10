//
//  FileManager+Extension.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/10.
//

import UIKit

extension UIViewController {
    
    // 경로찾기
    
    func getFilePath(fileName: String) -> URL? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        
        return documentDirectory.appendingPathComponent(fileName)
        
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) throws {
        
        guard let fileURL = getFilePath(fileName: fileName) else { return }
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch {
            throw ImageError.saveImageError // 뷰컨에서 처리
        }
        
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage {
        
        guard let fileURL = getFilePath(fileName: fileName) else { return UIImage(systemName: "cart")! }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)!
        } else {
            return UIImage(systemName: "cart")!
        }
        
    }
    
    func removeImageFromDocument(filename: String) throws {
        
        guard let fileURL = getFilePath(fileName: filename) else { return }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            throw ImageError.removeImageError
        }
        
        
    }
    
    func getFileName(productId: String) -> String {
        return "recap_\(productId).jpg"
    }
    
    
}
