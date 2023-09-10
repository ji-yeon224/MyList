//
//  SearchView.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit
import RealmSwift

class SearchView: BaseView {
    
    var cellDelegate: CollectionViewProtocol?
    var btnDelegate: LikeButtonProtocol?
    
    var items: [ItemElement] = []
    private let repository = LikeItemRepository()
    
    lazy var buttons: [UIButton] = [accuracySortButton, dateSortButton, highSortButton, lowSortButton]
    lazy var collectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout())
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = Constants.Color.background
        view.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        
        return view
    }()
    
    let accuracySortButton = {
        let view = SortButton()
        view.setTitle(title: " 정확도 ")
        view.tag = 0
        return view
    }()
    
    let dateSortButton = {
        let view = SortButton()
        view.setTitle(title: " 날짜순 ")
        view.tag = 1
        return view
    }()
    
    let highSortButton = {
        let view = SortButton()
        view.setTitle(title: " 가격높은순 ")
        view.tag = 2
        return view
    }()
    
    let lowSortButton = {
        let view = SortButton()
        view.setTitle(title: " 가격낮은순 ")
        view.tag = 3
        return view
    }()
    
    
    let searchBar = {
        let view = SearchBar()
        return view
    }()
    
    let buttonView = {
        let view = UIView()
        return view
    }()
    
    func setSortDesign(button: UIButton) {
        for item in buttons {
            item.backgroundColor = .black
            item.setTitleColor(Constants.Color.tintColor, for: .normal)
        }
        button.backgroundColor = .white
        button.setTitleColor(Constants.Color.background, for: .normal)
    
            
    }
    
    override func configure() {
        addSubview(searchBar)
        addSubview(buttonView)
        addSubview(collectionView)
        
        for item in buttons {
            buttonView.addSubview(item)
        }
        
        
    }
    
    override func setConstraints() {
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(10)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.equalTo(10)
            make.trailing.greaterThanOrEqualTo(-10)
            make.height.equalTo(30)
        }
        
        accuracySortButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(buttonView)
            make.leading.equalTo(safeAreaLayoutGuide).offset(20)
        }
        dateSortButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(buttonView)
            make.leading.equalTo(accuracySortButton.snp.trailing).offset(8)
        }
        highSortButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(buttonView)
            make.leading.equalTo(dateSortButton.snp.trailing).offset(8)
        }
        lowSortButton.snp.makeConstraints { make in
            make.verticalEdges.equalTo(buttonView)
            make.leading.equalTo(highSortButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualTo(safeAreaLayoutGuide).offset(-10)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(10)
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
    
    // 좋아요 목록에 존재하는지
    func isExistRecord(productId: String) -> LikeItem? {
        let result = repository.getItemByProductId(id: productId)
        return result
    }
    
    // 하트 이미지 변경
    func changeLikeButtonImage(like: Bool) -> UIImage {
        let image = like ? UIImage(systemName: "heart.fill")! : UIImage(systemName: "heart")!
        return image
    }
    
}

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let data = items[indexPath.row]
        
        
        cell.titleLabel.text = data.title.htmlToString()
        cell.mallLabel.text = data.mallName
        
        if let price = Int(data.lprice) {
            cell.priceLabel.text = price.numberFormatter()
        } else {
            cell.priceLabel.text = data.lprice
        }
        
        

        if let url = URL(string: data.image) {
            DispatchQueue.global().async {
                let imgURL = try! Data(contentsOf: url)
                DispatchQueue.main.async {
                    cell.imageView.image = UIImage(data: imgURL)
                }
            }
           
            
        } else {
            cell.imageView.image = UIImage(systemName: "cart")
        }
       
        
        // 좋아요 목록에 이미 존재한다면
        
        if isExistRecord(productId: data.productID) != nil {
            cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked(_ :)), for: .touchUpInside)
        return cell
    }
    
    // 좋아요 버튼 클릭 액션
    @objc private func likeButtonClicked(_ sender: UIButton) {
        if let cell  = sender.superview?.superview?.superview as? CollectionViewCell{
            if let indexPath = self.collectionView.indexPath(for: cell) {
                items[indexPath.row].like.toggle()
                cell.likeButton.setImage(changeLikeButtonImage(like: items[indexPath.row].like), for: .normal)
                btnDelegate?.buttonClickedAction(indexPath: indexPath, image: cell.imageView.image) // 액션 구현 뷰컨에 넘김
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellDelegate?.didSelectRowItemAt(indexPath: indexPath)
    }
    
}



