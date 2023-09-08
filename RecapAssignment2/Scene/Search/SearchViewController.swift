//
//  SearchViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit
import Alamofire


class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        self.view = mainView
        self.hideKeyboardWhenTappedAround()
        
        NaverAPI.shared.callShoppingRequest(endPoint: .shop, query: "캠핑카") { value in
            print("error")
            print(value)
        }
    }
    
    override func configure() {
        super.configure()
        title = "쇼핑검색"
    }
    
    
}

extension SearchViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        print(indexPath)
    }
}
