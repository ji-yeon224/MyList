//
//  LikeViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import UIKit
import RealmSwift

class LikeViewController: BaseViewController {
    
    private let mainView = LikeView()
    private let repository = LikeItemRepository()
    private let imageFileManager = ImageFileManager()
    var searchResult: Results<LikeItem>?
    var num = 1
    
    override func loadView() {
        mainView.cellDelegate = self
        mainView.btnDelegate = self
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        mainView.collectionView.reloadData()
        num = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchBar.delegate = self
        navigationItem.title = "좋아요 목록"
       
    }
    
    override func configure() {
        self.hideKeyboardWhenTappedAround()
        mainView.items = repository.fetch()
        
    }
    
}


extension LikeViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        guard let items = mainView.items else { return }
        let data = items[indexPath.row]
        
        let vc = DetailViewController()
        //vc.task = data
        
        let item = ItemElement(title: data.title, image: data.image, lprice: data.price, mallName: data.mallName, productID: data.productId, like: data.like)
        vc.item = item
        let cell = mainView.collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        vc.itemImage = cell?.imageView.image
        
        navigationController?.pushViewController(vc, animated: true)

        
        
    }
}

extension LikeViewController: LikeButtonProtocol {
    func buttonClickedAction(indexPath: IndexPath, image: UIImage?) {
        guard let items = mainView.items else { return }
        let item = items[indexPath.row]
        
        do {
            try imageFileManager.removeImageFromDocument(filename: imageFileManager.getFileName(productId: item.productId))
            try repository.deleteItem(item)
            mainView.collectionView.reloadData()
        } catch DataBaseError.deleteError {
            showAlertMessage(title: "좋아요 취소를 실패하였습니다.") {
                return
            }
        } catch ImageError.removeImageError {
            print("error")
            return
        } catch {
            return
        }
    }
}


extension LikeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            mainView.items = repository.searchItemByTitle(query: search)
        }
        view.endEditing(true)
 
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let search = searchBar.text?.trimmingCharacters(in: .whitespaces) {
            mainView.items = repository.searchItemByTitle(query: search)
        }
        mainView.collectionView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        
    }
    
    
}
