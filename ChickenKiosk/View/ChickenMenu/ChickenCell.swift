//
//  ChickenCell.swift
//  ChickenKiosk
//
//  Created by EMILY on 25/11/2024.
//

import UIKit
import SnapKit

class ChickenCell: UICollectionViewCell {
    static let identifier: String = "ChickenCell"
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubViews([imageView, textStackView])
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubViews([nameLabel, priceLabel])
        return stackView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private func layout() {
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalToSuperview().dividedBy(1.5)
            $0.centerX.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
    }
    
    func configure(_ chicken: Chicken) {
        imageView.image = chicken.image
        nameLabel.text = chicken.name
        priceLabel.text = chicken.priceText
    }
}
