//
//  CartView.swift
//  ChickenKiosk
//
//  Created by eden on 11/27/24.
//

import UIKit
import SnapKit

class CartView: UIView {
    
    weak var delegate: CartViewDelegate?
    
    private lazy var cartHeaderStackView = CartHeaderStackView()
    
    private lazy var cartTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.register(CartTableViewCell.self, forCellReuseIdentifier: "CartCell")
        tableView.separatorStyle = .singleLine
        tableView.isHidden = true
        
        return tableView
    }()
    
    private lazy var emptyCartLabel: UILabel = {
        let label = UILabel()
        label.text = "장바구니가 비어있습니다"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .center
        label.isHidden = false
        return label
    }()
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        addSubViews([cartHeaderStackView, emptyCartLabel, cartTableView])
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        backgroundColor = .white
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.appSecondary.cgColor
        
        cartHeaderStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(15)
        }
        
        emptyCartLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        cartTableView.snp.makeConstraints { make in
            make.top.equalTo(cartHeaderStackView.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func reloadData() {
        guard let delegate = delegate else { return }
        cartTableView.reloadData()
        cartHeaderStackView.updateTotalCount(newCount: delegate.getTotalOrderCount())
        emptyCartLabel.isHidden = delegate.getOrdersInfo().count > 0
        cartTableView.isHidden = !emptyCartLabel.isHidden
    }
}

extension CartView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let orders = delegate?.getOrdersInfo() else { return 0 }
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let orders = delegate?.getOrdersInfo(),
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartTableViewCell
        else { return UITableViewCell () }
        
        let index = indexPath.row
        
        cell.configure(with: orders[index])
        
        cell.minusButtonTapped = { [weak self] in
            self?.delegate?.didTapMinusButton(of: index)
        }
        
        cell.plusButtonTapped = { [weak self] in
            self?.delegate?.didTapPlusButton(of: index)
        }
        
        return cell
    }
}
