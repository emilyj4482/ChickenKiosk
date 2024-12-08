//
//  MenuView.swift
//  ChickenKiosk
//
//  Created by EMILY on 28/11/2024.
//

import UIKit

class MenuView: UIView {
    
    weak var delegate: CategorySelectDelegate?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ChickenCell.self, forCellWithReuseIdentifier: ChickenCell.identifier)
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.hidesForSinglePage = true
        
        return pageControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubViews([collectionView, pageControl])
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        layer.cornerRadius = 20.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.appSecondary.cgColor
        
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-8)
        }
        
        pageControl.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-5)
            $0.centerX.equalToSuperview()
        }
    }
}

extension MenuView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let series = delegate?.getSeriesInfo() else { return 0 }
        return series.chickens.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let series = delegate?.getSeriesInfo(),
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChickenCell.identifier, for: indexPath) as? ChickenCell
        else { return UICollectionViewCell() }
        
        cell.bind(series.chickens[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapChickenCell(of: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 10) / 2
        let height = (collectionView.bounds.height - 10) / 2
        let size = CGSize(width: width, height: height)
        return size
    }
}
