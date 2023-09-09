//
//  DetailViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import UIKit
import WebKit
import RealmSwift

class DetailViewController: BaseViewController, WKUIDelegate {
    
    var task: LikeItem?
    

    var webView: WKWebView!
    var like: Bool = false
    
    private let repository = LikeItemRepository()
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let task = task else {
            showAlertMessage(title: "해당 상품이 존재하지 않습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        title = task.title
        
    }
    
    
    override func configure() {
        super.configure()
        setNavigationItem()
        
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        //바 틴트 바꾸는 것
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        
        guard let task = task else {
            showAlertMessage(title: "해당 상품이 존재하지 않습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            
            return
        }
        let urlString = URL.makeDetailURL(productId: task.productId)
        guard let url = URL(string: urlString) else {
            showAlertMessage(title: "URL 주소가 잘못되었습니다.") {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func setNavigationItem() {
        navigationItem.backBarButtonItem?.title = "상품 검색"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: setLikeButtonImage(), style: .plain, target: self, action: #selector(likeButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = Constants.Color.tintColor
        navigationItem.titleView?.tintColor = Constants.Color.tintColor
        
    }
    
    @objc private func likeButtonClicked() {
        like.toggle()
        
        
        
        navigationItem.rightBarButtonItem?.image = setLikeButtonImage()
    }
    
    func setLikeButtonImage() -> UIImage{
        if like {
            return UIImage(systemName: "heart.fill")!
        } else {
            return UIImage(systemName: "heart")!
        }
    }
    
    
}
