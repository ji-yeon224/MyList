//
//  CollectionViewCell.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit

class CollectionViewCell: BaseCollctionViewCell {
    
    let imageView = {
        let view = ItemImageView(frame: .zero)
        view.backgroundColor = .darkGray
        return view
    }()
    
    let likeButton = {
        let view = LikeButton()
        return view
    }()
    
    
    let mallLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.subText
        view.font = .systemFont(ofSize: 13)
        view.numberOfLines = 1
        view.text = "mall"
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.text
        view.font = .systemFont(ofSize: 13)
        view.numberOfLines = 2
        view.text = "title"
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.textColor = Constants.Color.text
        view.font = .boldSystemFont(ofSize: 20)
        view.numberOfLines = 1
        view.text = numberFormatter(num: 1234567889111111110)
        view.adjustsFontSizeToFitWidth = true
        view.minimumScaleFactor = 0.5
        return view
    }()
    
    
    
    override func configure() {
        contentView.addSubview(imageView)
        imageView.addSubview(likeButton)
        contentView.addSubview(mallLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        
        
    }
    
    override func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView)
            make.width.equalTo(contentView)
            make.height.equalTo(self.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(imageView).inset(5)
            make.size.equalTo(30)
        }
        
        mallLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView)
        }
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.horizontalEdges.equalTo(contentView)
            make.bottom.greaterThanOrEqualTo(5)
        }
        
    }
    
}
