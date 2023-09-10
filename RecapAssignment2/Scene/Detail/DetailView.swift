//
//  DetailView.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/10.
//

import UIKit
import WebKit

final class DetailView: BaseView, WKUIDelegate {
    
    var webView = WKWebView()
    
    override func configure() {

        addSubview(webView)
    }
    
    override func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
    
}
