//
//  LikeView.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/09.
//

import UIKit
import RealmSwift

class LikeView: BaseView {
    
    var cellDelegate: CollectionViewProtocol?
    var btnDelegate: LikeButtonProtocol?
    
    private let imageFileManager = ImageFileManager()
    
    var items: Results<LikeItem>?
    var images: [String : UIImage]?
    
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout())
        view.backgroundColor = Constants.Color.background
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    let searchBar = {
        let view = SearchBar()
        return view
    }()
    
    override func configure() {
        addSubview(searchBar)
        addSubview(collectionView)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
            
        }
    }
    
    private func collectionViewlayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let width = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        
        return layout
    }
    
}

extension LikeView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = items else { return 0 }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        
        guard let items = items else { return UICollectionViewCell() }
        let data = items[indexPath.row]
        
        
        cell.titleLabel.text = data.title.htmlToString()
        cell.mallLabel.text = data.mallName
        
        if let price = Int(data.price) {
            cell.priceLabel.text = price.numberFormatter()
        } else {
            cell.priceLabel.text = data.price
        }
        

        
        cell.imageView.image = imageFileManager.loadImageFromDocument(fileName: imageFileManager.getFileName(productId: data.productId))
        
        
        cell.likeButton.setImage(UIImage(systemName: "heart.fill")!, for: .normal)
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked(_ :)), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc private func likeButtonClicked(_ sender: UIButton) {
        if let cell  = sender.superview?.superview?.superview as? CollectionViewCell{
            if let indexPath = self.collectionView.indexPath(for: cell) {
                btnDelegate?.buttonClickedAction(indexPath: indexPath, image: cell.imageView.image)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDelegate?.didSelectRowItemAt(indexPath: indexPath)
    }
    
}
