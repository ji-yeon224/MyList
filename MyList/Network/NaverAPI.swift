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
    
    func callShoppingRequest(endPoint: EndPoint, query: String, sort: Sort, startIdx: Int, successHandler: @escaping (Search) -> Void, faliureHandler: @escaping (AFError) -> Void) throws {
        
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        guard let text = text else {
            throw ValidationError.invalidValue
        }
        let url = EndPoint.shop.requestURL + makeParameterString(query: text, sort: sort, startIdx: startIdx)

        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: Search.self) { response in
                switch response.result {
                case .success(let value): successHandler(value)
                case .failure(let error):
                    faliureHandler(error)
                }
                
            }
        
    }
    
    private func makeParameterString(query: String, sort: Sort, startIdx: Int) -> String {
        return "query=\(query)&display=30&sort=\(sort.rawValue)&start=\(startIdx)"
    }
    
}

