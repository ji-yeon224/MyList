//
//  SearchViewController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit



class SearchViewController: BaseViewController {
    
    let mainView = SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        self.view = mainView
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func configure() {
        super.configure()
        title = "쇼핑검색"
    }
    
    override func setConstraints() {
        
    }
    
    
    
}

extension SearchViewController: CollectionViewProtocol {
    func didSelectRowItemAt(indexPath: IndexPath) {
        print(indexPath)
    }
}
