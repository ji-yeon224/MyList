//
//  SearchView.swift
//  RecapAssignment2
//
//  Created by 김지연 on 2023/09/07.
//

import UIKit

class SearchView: BaseView {
    
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
        return view
    }()
    
    let dateSortButton = {
        let view = SortButton()
        view.setTitle(title: " 날짜순 ")
        return view
    }()
    
    let highSortButton = {
        let view = SortButton()
        view.setTitle(title: " 가격높은순 ")
        return view
    }()
    
    let lowSortButton = {
        let view = SortButton()
        view.setTitle(title: " 가격낮은순 ")
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
    
    override func configure() {
        addSubview(searchBar)
        addSubview(buttonView)
        addSubview(collectionView)
        buttonView.addSubview(accuracySortButton)
        buttonView.addSubview(dateSortButton)
        buttonView.addSubview(highSortButton)
        buttonView.addSubview(lowSortButton)
        
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
}

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
    
}
