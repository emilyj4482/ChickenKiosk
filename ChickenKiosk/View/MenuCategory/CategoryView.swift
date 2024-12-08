//
//  CategoryView.swift
//  ChickenKiosk
//
//  Created by EMILY on 08/12/2024.
//

import UIKit

class CategoryView: UIView {
    
    private let buttons = [CategoryButton(.honey), CategoryButton(.red), CategoryButton(.kyochon)]
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubViews(buttons)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        backgroundColor = .clear
        layer.cornerRadius = 20
        
        buttons.forEach {
            $0.snp.makeConstraints {
                $0.width.equalToSuperview().dividedBy(3)
                $0.height.equalToSuperview()
                $0.centerY.equalToSuperview()
            }
            
            $0.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
        }
        
        buttons[0].snp.makeConstraints {
            $0.leading.equalToSuperview()
        }
        
        buttons[1].snp.makeConstraints {
            $0.centerX.equalToSuperview()
        }
        
        buttons[2].snp.makeConstraints {
            $0.trailing.equalToSuperview()
        }
        
        // 허니시리즈 버튼은 눌린 채로 시작
        setButtonSelected(for: buttons[0])
    }
    
    private func setButtonSelected(for button: UIButton) {
        buttons.forEach {
            $0.backgroundColor = .clear
            $0.isSelected = false
        }
        
        button.backgroundColor = .appPrimary
        button.isSelected = true
    }
    
    @objc func categoryTapped(_ sender: CategoryButton) {
        setButtonSelected(for: sender)
    }
}
