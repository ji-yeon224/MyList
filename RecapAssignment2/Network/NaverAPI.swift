//
//  NaverAPI.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/08.
//

import Foundation
import Alamofire

final class NaverAPI {
    
    static let shared = NaverAPI()
    private init() { }
    
    
    private let header: HTTPHeaders = ["X-Naver-Client-Id": "\(APIKey.naverId)", "X-Naver-Client-Secret": "\(APIKey.naverSecret)"]
    
    func callShoppingRequest(endPoint: EndPoint, query: String, completionHandler: @escaping (Search) -> ()) {
        
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = EndPoint.shop.requestURL + "\(text!)"
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: Search.self) { response in
                switch response.result {
                case .success(let value): completionHandler(value)
                case .failure(let error): print(error)
                }
                
            }
        
    }
    
}

