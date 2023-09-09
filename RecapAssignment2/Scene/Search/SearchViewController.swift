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
    var startIdx = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        mainView.searchBar.delegate = self
        mainView.collectionView.prefetchDataSource = self
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
            startIdx = 1
            sortType = sortAllCase[sender.tag]
            mainView.items.removeAll()
            callRequest(query: keyword, sort: sortType, startIdx: startIdx)
        }
        mainView.setSortDesign(button: sender)
        
    
    }
    
    
}

extension SearchViewController {
    func callRequest(query: String, sort: Sort, startIdx: Int) {
        do {
            try NaverAPI.shared.callShoppingRequest(endPoint: .shop, query: query, sort: sort, startIdx: startIdx) { data in
                self.mainView.items.append(contentsOf: data.items)
                self.mainView.collectionView.reloadData()
                if startIdx == 1 {
                    self.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            } faliureHandler: { error in
                print(error)
                self.showAlertMessage(title: "다시 시도해주세요.") { }
                return
            }
            
        } catch {
            showAlertMessage(title: "올바른 검색어를 입력해주세요.") { }
            return
        }
        
        
    }
}

extension SearchViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        print(mainView.items[indexPath.row])
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if mainView.items.count - 1 == indexPath.row {
                startIdx += 30
                callRequest(query: keyword, sort: sortType, startIdx: startIdx)
            }
        }
        
    }
   
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let search = searchBar.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        keyword = search
        callRequest(query: search, sort: sortType, startIdx: startIdx)
        view.endEditing(true)
 
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
            keyword = ""
            startIdx = 1
            mainView.items.removeAll()
            mainView.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
    
}
