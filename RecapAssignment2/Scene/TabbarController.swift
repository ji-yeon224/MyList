//
//  TabbarController.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import UIKit

class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = SearchViewController()
        let vc2 = LikeViewController()
        
        self.tabBar.tintColor = Constants.Color.tintColor
        self.tabBar.unselectedItemTintColor = .darkGray
        
        vc1.tabBarItem.title = "검색"
        vc1.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc2.tabBarItem.title = "좋아요"
        vc2.tabBarItem.image = UIImage(systemName: "heart")
        
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.navigationItem.title = "상품 검색"
        nav1.navigationBar.tintColor = .white
        let nav2 = UINavigationController(rootViewController: vc2)
        nav2.navigationItem.title = "좋아요 목록"
        
        setViewControllers([nav1, nav2], animated: true)
        
    }
}
