//
//  CartTableViewCell.swift
//  ChickenKiosk
//
//  Created by eden on 11/28/24.
//

import UIKit
import SnapKit

class CartTableViewCell: UITableViewCell {
    private let menuLabel = UILabel()
    private let decreaseQuantityButton = UIButton()
    private let quantityLabel = UILabel()
    private let increaseQuantityButton = UIButton()
    private let priceLabel = UILabel()
    
    var minusButtonTapped: () -> Void = {}
    var plusButtonTapped: () -> Void = {}
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpCell()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpCell() {
        // 메뉴, 수량, 가격 설정
        menuLabel.font = UIFont.systemFont(ofSize: 14)
        menuLabel.textAlignment = .left
        menuLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        decreaseQuantityButton.setTitle("-", for: .normal)
        decreaseQuantityButton.setTitleColor(.black, for: .normal)
        decreaseQuantityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        decreaseQuantityButton.addTarget(self, action: #selector(decreaseButtonTapped), for: .touchUpInside)
        
        quantityLabel.font = UIFont.systemFont(ofSize: 14)
        quantityLabel.textAlignment = .center
        quantityLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        increaseQuantityButton.setTitle("+", for: .normal)
        increaseQuantityButton.setTitleColor(.black, for: .normal)
        increaseQuantityButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        increaseQuantityButton.addTarget(self, action: #selector(increaseButtonTapped), for: .touchUpInside)
        
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textAlignment = .right
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        // 수량 조절 스택 뷰 생성
        let quantityStackView = UIStackView(arrangedSubviews: [decreaseQuantityButton, quantityLabel, increaseQuantityButton])
        quantityStackView.axis = .horizontal
        quantityStackView.spacing = 8
        quantityStackView.alignment = .center
        quantityStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        // 전체 셀 스택 뷰 생성
        let cellStackView = UIStackView(arrangedSubviews: [menuLabel, UIView(), quantityStackView, UIView(), priceLabel])
        cellStackView.axis = .horizontal
        cellStackView.alignment = .center
        cellStackView.spacing = 10
        cellStackView.distribution = .equalSpacing
        
        contentView.addSubview(cellStackView)
        
        cellStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        quantityStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(with order: Order) {
        menuLabel.text = order.menu.name
        quantityLabel.text = "\(order.count)"
        priceLabel.text = "\(order.totalPrice.formatted(.number))"
    }
    
    @objc
    func decreaseButtonTapped() {
        minusButtonTapped()
    }
    
    @objc
    func increaseButtonTapped() {
        plusButtonTapped()
    }
}
