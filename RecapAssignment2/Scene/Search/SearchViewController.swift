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
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        self.view = mainView
        self.hideKeyboardWhenTappedAround()
        
        callRequest()
        
        group.notify(queue: .main) {
            self.mainView.collectionView.reloadData()
        }
        
    }
    
    override func configure() {
        super.configure()
        title = "상품 검색"
    }
    
    
}

extension SearchViewController {
    func callRequest() {
        group.enter()
        do {
            try NaverAPI.shared.callShoppingRequest(endPoint: .shop, query: "캠핑카") { data in
                //print(data)
                self.mainView.items = data.items
                //print(data.items)
                self.group.leave()
            } faliureHandler: { error in
                print(error)
                self.showAlertMessage(title: "error") {
                    
                }
                
            }
            
        } catch {
            print()
        }
        
        
    }
}

extension SearchViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        print(indexPath)
    }
}
