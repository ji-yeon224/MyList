//
//  DetailViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import UIKit
import WebKit
import RealmSwift

final class DetailViewController: BaseViewController, WKUIDelegate {
    
    
    var item: ItemElement?
    var itemImage: UIImage?
    
    var like: Bool = false
    private let repository = LikeItemRepository()
    private let imageFileManager = ImageFileManager()
    
    private let mainView = DetailView()
    
    override func loadView() {
        
        self.view = mainView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try loadWebView()
        } catch NetworkError.nonExistItem {
            showAlertMessage(title: "", message: "URL 주소가 잘못되었습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
        } catch NetworkError.invalidURL {
            showAlertMessage(title: "", message: "URL 주소가 잘못되었습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            showAlertMessage(title: "", message: "오류가 발생하였습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
    }
    
    private func loadWebView() throws {
        guard let item = item else {
            throw NetworkError.nonExistItem
        }
        let urlString = URL.makeDetailURL(productId: item.productID)
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        let request = URLRequest(url: url)
        mainView.webView.load(request)
    }
    
    
    override func configure() {
        super.configure()
        
        do {
            try setValue()
        } catch {
            showAlertMessage(title: "", message: "해당 상품이 존재하지 않습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        setNavigationBar()
        setNavigationItem()
        changeNavBarButton(like: like)
    }
    
    private func setValue() throws {
        guard let item = item else {
            throw NetworkError.nonExistItem
        }
        
        title = item.title.htmlToString()
        like = item.like
        
    }
    
    private func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = Constants.Color.background
        navigationController?.navigationBar.tintColor = Constants.Color.tintColor
        navigationController?.navigationBar.standardAppearance = appearance
    }
    
    private func setNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.tintColor
        navigationItem.titleView?.tintColor = Constants.Color.tintColor
        
    }
    
    @objc private func likeButtonClicked() {
        
        like.toggle()
        changeNavBarButton(like: like)
        
        do {
            try setLikeButtonAction()
        } catch {
            showAlertMessage(title: "", message: "오류가 발생하였습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func setLikeButtonAction() throws {
        guard let item = item else {
            self.navigationController?.popViewController(animated: true)
            throw ValidationError.invalidValue
        }
        
        if let task = repository.getItemByProductId(id: item.productID) { //이미 좋아요 누른 목록
            do {
                try imageFileManager.removeImageFromDocument(filename: imageFileManager.getFileName(productId: item.productID))
                try repository.deleteItem(task)
            } catch DataBaseError.deleteError {
                showAlertMessage(title: "", message: "좋아요 취소를 실패하였습니다.") { }
            } catch ImageError.removeImageError {
                showAlertMessage(title: "", message: "좋아요 취소를 실패하였습니다.") { }
            } catch {
                showAlertMessage(title: "", message: "오류가 발생하였습니다.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        } else { // 좋아요 등록
            let task = LikeItem(productId: item.productID, title: item.title, image: item.image, price: item.lprice, mallName: item.mallName, like: true)
            do {
                try repository.createItem(task)
                try imageFileManager.saveImageToDocument(fileName: imageFileManager.getFileName(productId: item.productID), image: itemImage ?? UIImage(systemName: "cart")!)
            } catch {
                showAlertMessage(title: "", message: "좋아요 반영에 실패했습니다.") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    
    private func changeNavBarButton(like: Bool) {
        if like {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
    }
    
    
}
