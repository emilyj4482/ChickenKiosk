//
//  CategorySelectDelegate.swift
//  ChickenKiosk
//
//  Created by EMILY on 08/12/2024.
//

import Foundation

protocol CategorySelectDelegate: AnyObject {
    func updateCategory(_ series: ChickenSeries)
    func getSeriesInfo() -> ChickenSeries
    func didTapChickenCell(of index: Int)
}
