//
//  CategoryView.swift
//  ChickenKiosk
//
//  Created by EMILY on 08/12/2024.
//

import UIKit

class CategoryView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .clear
        layer.cornerRadius = 20
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
