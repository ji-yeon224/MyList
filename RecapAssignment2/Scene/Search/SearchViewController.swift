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
    var searchKeyword = ""
    let sortAllCase = Sort.allCases
    var keyword = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        mainView.searchBar.delegate = self
        self.view = mainView
        
        
    }
    
    override func configure() {
        super.configure()
        title = "상품 검색"
        sortButtonAction()
        self.hideKeyboardWhenTappedAround()
        mainView.setSortDesign(button: mainView.accuracySortButton)
    }
    
    func sortButtonAction() {
        
        mainView.accuracySortButton.addTarget(self, action:  #selector(buttonClicked(_ :)), for: .touchUpInside)
        mainView.dateSortButton.addTarget(self, action: #selector(buttonClicked(_ :)), for: .touchUpInside)
        mainView.highSortButton.addTarget(self, action:  #selector(buttonClicked(_ :)), for: .touchUpInside)
        mainView.lowSortButton.addTarget(self, action:  #selector(buttonClicked(_ :)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_ sender: UIButton) {
        
        if keyword.count != 0 {
            sortType = sortAllCase[sender.tag]
            callRequest(query: keyword, sort: sortType)
            
        }
        mainView.setSortDesign(button: sender)
        
    }
    
    
}

extension SearchViewController {
    func callRequest(query: String, sort: Sort) {
        group.enter()
        do {
            try NaverAPI.shared.callShoppingRequest(endPoint: .shop, query: query, sort: sort) { data in
                self.mainView.items = data.items
                self.group.leave()
            } faliureHandler: { error in
                print(error)
                self.showAlertMessage(title: "다시 시도해주세요.") { }
                
            }
            
        } catch {
            showAlertMessage(title: "올바른 검색어를 입력해주세요.") { }
        }
        
        group.notify(queue: .main) {
            self.mainView.collectionView.reloadData()
            self.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
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
        keyword = search
        callRequest(query: search, sort: sortType)
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            keyword = ""
            mainView.items.removeAll()
            mainView.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
}
