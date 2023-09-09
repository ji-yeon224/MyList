//
//  SearchViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit
import Alamofire


final class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    let group = DispatchGroup()
    var sortType: Sort = .sim
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        mainView.searchBar.delegate = self
        self.view = mainView
        self.hideKeyboardWhenTappedAround()
        
        
        
        
    }
    
    override func configure() {
        super.configure()
        title = "상품 검색"
    }
    
    
}

extension SearchViewController {
    func callRequest(query: String, sort: Sort) {
        group.enter()
        do {
            try NaverAPI.shared.callShoppingRequest(endPoint: .shop, query: query, sort: sort) { data in
                //print(data)
                self.mainView.items = data.items
                self.group.leave()
            } faliureHandler: { error in
                print(error)
                self.showAlertMessage(title: "다시 시도해주세요.") { }
                
            }
            
        } catch {
            showAlertMessage(title: "올바른 검색어를 입력해주세요.") { }
        }
        
        
    }
}

extension SearchViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        print(mainView.items[indexPath.row])
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        callRequest(query: search, sort: sortType)
        view.endEditing(true)
        group.notify(queue: .main) {
            self.mainView.collectionView.reloadData()
            self.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            mainView.items.removeAll()
            mainView.collectionView.reloadData()
        }
    }
}
