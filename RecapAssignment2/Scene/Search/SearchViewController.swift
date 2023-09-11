//
//  SearchViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit
import Alamofire


final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    private var sortType: Sort = .sim
    private var searchKeyword = ""
    private let sortAllCase = Sort.allCases
    private var keyword = ""
    private var startIdx = 1
    private var total = 0
    
    private let repository = LikeItemRepository()
    private let imageFileManager = ImageFileManager()
    
    override func loadView() {
        mainView.cellDelegate = self
        mainView.btnDelegate = self
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.searchBar.delegate = self
        mainView.collectionView.prefetchDataSource = self
        navigationItem.title = "상품 검색"
        //print(repository.getRealmFilePath())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.collectionView.reloadData()
    }
    
    override func configure() {
        super.configure()
        
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
                
                self.total = data.total
                if data.items.count == 0 && startIdx == 1{
                    self.showAlertMessage(title: "", message: "검색 결과가 없습니다.") { }
                }
                self.mainView.items.append(contentsOf: data.items)
                self.mainView.collectionView.reloadData()
                if startIdx == 1 && self.mainView.items.count != 0{
                    self.mainView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
            } faliureHandler: { error in
                print(error)
                self.showAlertMessage(title: "NetWorkError", message: "인터넷 연결 확인 후 다시 시도해주세요.") { }
            }
            
        } catch {
            showAlertMessage(title: "", message: "올바른 검색어를 입력해주세요.") { }
        }
        
        
    }
}

extension SearchViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        let item = mainView.items[indexPath.row]
        let vc = DetailViewController()
        vc.item = item
        let cell = mainView.collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        vc.itemImage = cell?.imageView.image
        navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}

extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if mainView.items.count - 6 == indexPath.row {
                
                if total >= startIdx && startIdx + 30 <= 1000 {
                    startIdx += 30
                    callRequest(query: keyword, sort: sortType, startIdx: startIdx)
                }
                
            }
        }
        
        
        
        
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            keyword = search
            
            if mainView.items.count > 0 {
                startIdx = 1
                total = 0
                mainView.items.removeAll()
            }
            
            callRequest(query: search, sort: sortType, startIdx: startIdx)
            view.endEditing(true)
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            keyword = ""
            startIdx = 1
            total = 0
            mainView.items.removeAll()
            mainView.collectionView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
    
}

extension SearchViewController: LikeButtonProtocol {
    func buttonClickedAction(indexPath: IndexPath, image: UIImage?) {
        let item = mainView.items[indexPath.row]
        
        
        if let task = repository.getItemByProductId(id: item.productID) { // 좋아요 해제
            do {
                try imageFileManager.removeImageFromDocument(filename: imageFileManager.getFileName(productId: item.productID))
                try repository.deleteItem(task)
            } catch DataBaseError.deleteError {
                showAlertMessage(title: "", message: "좋아요 취소를 실패하였습니다.") { }
            } catch ImageError.removeImageError {
                showAlertMessage(title: "", message: "좋아요 취소를 실패하였습니다.") { }
            } catch {
                showAlertMessage(title: "", message: "오류가 발생하였습니다.") { }
            }
            
        } else { // 좋아요 등록
            let like = LikeItem(productId: item.productID, title: item.title.htmlToString(), image: item.image, price: item.lprice, mallName: item.mallName, like: true)
            
            do {
                try imageFileManager.saveImageToDocument(fileName: imageFileManager.getFileName(productId: item.productID), image: image ?? UIImage(systemName: "cart")!)
                try repository.createItem(like)
                
            } catch DataBaseError.createError {
                showAlertMessage(title: "", message: "좋아요 반영에 실패했습니다.") {}
            } catch ImageError.saveImageError {
                showAlertMessage(title: "", message: "좋아요 반영에 실패했습니다.") {}
            } catch {
                showAlertMessage(title: "", message: "오류가 발생하였습니다.") { }
            }
        }
        
        
    }
}
