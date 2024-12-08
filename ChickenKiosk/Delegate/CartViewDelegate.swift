//
//  CartViewDelegate.swift
//  ChickenKiosk
//
//  Created by EMILY on 08/12/2024.
//

import Foundation

protocol CartViewDelegate: AnyObject {
    func getOrdersInfo() -> [Order]
    func didTapMinusButton(of index: Int)
    func didTapPlusButton(of index: Int)
    func getTotalOrderCount() -> Int
}
