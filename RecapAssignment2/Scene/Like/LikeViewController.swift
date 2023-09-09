//
//  LikeViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import UIKit

class LikeViewController: BaseViewController {
    
    private let mainView = LikeView()
    private let repository = LikeItemRepository()
    
    override func loadView() {
        mainView.cellDelegate = self
        mainView.btnDelegate = self
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainView.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "좋아요 목록"
        
        mainView.items = repository.fetch()
        
        
    }
    
}

extension LikeViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        guard let items = mainView.items else { return }
        let data = items[indexPath.row]
        
        let vc = DetailViewController()
        vc.task = data
        
        
        
        navigationController?.pushViewController(vc, animated: true)

        
        
    }
}

extension LikeViewController: LikeButtonProtocol {
    func buttonClickedAction(indexPath: IndexPath) {
        guard let items = mainView.items else { return }
        let item = items[indexPath.row]
        
        do {
            try repository.deleteItem(item)
            mainView.collectionView.reloadData()
        } catch {
            showAlertMessage(title: "좋아요 취소를 실패하였습니다.") {
                return
            }
        }
    }
}

