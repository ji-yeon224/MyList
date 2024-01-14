//
//  UIImage+Extension.swift
//  RecapAssignment2
//
//  Created by 김지연 on 12/29/23.
//

import UIKit

extension UIImage {
    func downSample(to size: CGFloat) -> UIImage? {
        let options: [CFString: Any] = [
            kCGImageSourceShouldCache: false,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
            kCGImageSourceThumbnailMaxPixelSize: size * UIScreen.main.scale,
            kCGImageSourceCreateThumbnailWithTransform: true
        ]
        
        guard
            let data = jpegData(compressionQuality: 1.0),
            let imageSource = CGImageSourceCreateWithData(data as CFData, nil),
            let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary)
        else { return nil }
        
        let resizedImage = UIImage(cgImage: cgImage)
        return resizedImage
    }
    
}
