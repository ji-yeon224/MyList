
<img src = "https://github.com/ji-yeon224/MyList/assets/69784492/d6e3d403-1c7a-4442-b220-094133a924f0" width="18%"/>

# 🛒 MyList

<img src = "https://github.com/ji-yeon224/MyList/assets/69784492/936464db-0e19-48d4-b399-4bc8b30aca52" width="80%"/>

</br>

## 🗓️ 프로젝트
- 최소 버전 iOS 13.0
- 23.09.07 ~ 23.09.11 (5일)
- 구매하고 싶은 나의 쇼핑 리스트를 검색하고 저장할 수 있는 어플리케이션
</br>

## 💻 기술 스택
- `MVC`
- `UIKit`, `WebKit` 
- `SnapKit`, `Alamofire`, `Codable`, `Realm`, `Kingfisher`, `NWPathMonitor`
</br>

## 📖 주요 기능
- 네이버 쇼핑 API를 활용해 상품 검색과 검색 결과 정렬
- 좋아요 버튼으로 나의 쇼핑 목록에 저장 또는 삭제
- 나의 쇼핑 목록에서 상품 검색 기능
</br>

## 💡 핵심 기술
-  CollectionView `PrefetchForItems를` 활용하여 **페이지네이션** 구현
-  `RealmDB`를 활용하여 구매하고 싶은 상품을 저장하여 검색, 조회 기능 구현
- `Kingfisher`를 활용하여 상품 이미지 다운로드와 **다운샘플링 구현**
- `NWPathMonitor`를 활용하여 네트워크 연결 상태 모니터링
- `WebKit`을 통해 외부 링크를 앱 내부에서 로드
</br>

## 🚨 트러블 슈팅
### 이미지 다운로드 속도 저하

- 네트워크 통신을 이용하여 상품 이미지 다운로드 구현 시 UIImage(data: )를 사용하였다. DispatchQueue를 사용하여 비동기 방식으로 구현했음에도 불구하고 이미지의 크기가 큰 경우 다운로드 속도가 느려 스크롤 시 끊겨보이는 현상이 발생하였다.
-  **이미지 다운로드 속도를 향상**시키기 위해 **Kingfisher** 라이브러리를 사용하였다.
```swift
if let url = URL(string: data.image) {
    cell.imageView.kf.setImage(with: url) { result in
        switch result {
        case .success(let data):
            cell.imageView.image = data.image
        case .failure(_):
            cell.imageView.backgroundColor = .white
        }
    }
} else {
    cell.imageView.backgroundColor = .white
} 
```

### 이미지 다운로드 시 메모리 과사용

- Kingfisher 라이브러리를 사용하여 이미지 다운로드 구현 시 **메모리 과사용 문제가 발생**하였다. 
- 다운샘플링을 통해 **이미지의 해상도를 줄여** 메모리 사용량을 최대 257mb에서 최대 79mb까지 줄였다.
```swift
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
```
